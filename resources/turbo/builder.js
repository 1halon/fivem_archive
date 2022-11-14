let progress = {
  building: false,
  module: null,
  reset() {
    this.building = false;
    this.module = null;
  },
};

const { spawn } = require("child_process"),
  { createWriteStream, existsSync, statSync, mkdirSync } = require("fs"),
  { readdir, readFile } = require("fs/promises"),
  { join, dirname } = require("path"),
  __resource = GetCurrentResourceName();
(excludedDirs = [".turbo", "node_modules"]),
  (dirSize = async (path) => {
    const files = (await readdir(path)).map((file) => {
      const _path = join(path, file);
      return { name: file, path: _path, stats: statSync(_path) };
    });

    return files.reduce(
      (prev, { stats: { size } }) => prev + size,
      (
        await Promise.all(
          files
            .filter((file) => !excludedDirs.includes(file.name))
            .filter((file) => file.stats.isDirectory())
            .map((dir) => dirSize(dir.path))
        )
      ).reduce((prev, curr) => prev + curr, 0)
    );
  }),
  (checkBuildSize = async (resource_path, cache_path) => {
    const resource_size = await dirSize(resource_path),
      cache_size = Number(await readFile(cache_path).catch(() => 0));

    return [
      resource_size === cache_size,
      resource_size,
      cache_size,
      resource_size - cache_size,
    ];
  }),
  (buildTurbo = (path, resourceName, progress, cbf, cbt, cache_path) => {
    const process = spawn("npx", ["turbo", "build", "--no-daemon"], {
      cwd: path,
      stdio: "pipe",
    })
      .on("spawn", () => console.log(`[${resourceName}] building...`))
      .on("exit", function (code, signal) {
        setImmediate(async function () {
          progress.reset();
          if (code !== 0 || signal) return cbf("build failed.");

          write(cache_path, String(await dirSize(path)));
          write(
            cache_path.replace("size", "package_size"),
            String(statSync(`${path}/package.json`).size)
          );

          function write(path, size) {
            if (!existsSync(path))
              mkdirSync(dirname(path), { recursive: true });
            createWriteStream(path, {
              flags: "w+",
            }).end(size);
          }

          cbt();
        });
      });

    process.stdout.on("data", (data) => console.log(data.toString()));
    process.stderr.on("data", (data) => console.error(data.toString()));
  });
installPackages = (path, resourceName, progress, cbf, ...args) => {
  const process = spawn("npm", ["i"], { cwd: path, stdio: "pipe" })
    .on("spawn", () => console.log(`[${resourceName}] installing packages...`))
    .on("exit", function (code, signal) {
      setImmediate(function () {
        if (code !== 0 || signal) {
          progress.reset();
          return cbf("Installation failed!");
        }

        buildTurbo(path, resourceName, progress, cbf, ...args);
      });
    });

  process.stdout.on("data", (data) => console.log(data.toString()));
  process.stderr.on("data", (data) => console.error(data.toString()));
};
(built_resources = {}),
  (buildTask = {
    shouldBuild: (resourceName) =>
      GetResourceMetadata(resourceName, __resource) === "yes" &&
      !built_resources[resourceName],

    build(resourceName, cb) {
      (async function () {
        while (progress.building && progress.module !== resourceName) {
          await new Promise((resolve) => setTimeout(resolve, 5e3));
        }

        const path = `${GetResourcePath(resourceName)}`,
          cache_path = `cache/${__resource}/${resourceName}/size`,
          cbf = cb.bind(this, false),
          cbt = () => {
            built_resources[resourceName] = true;
            cb(true);
          },
          args = [path, resourceName, progress, cbf, cbt, cache_path];

        if (!existsSync(`${path}/turbo.json`))
          return cbf("[NOT FOUND] turbo.json");

        progress = {
          ...progress,
          building: true,
          module: resourceName,
        };

        if (
          !existsSync(`${path}/node_modules`) ||
          !existsSync(`${path}/package-lock.json`) ||
          statSync(`${path}/package.json`).size !==
            Number(
              await readFile(cache_path.replace("size", "package_size")).catch(
                () => 0
              )
            )
        )
          return installPackages(...args);

        const [isEqual, resource_size, cache_size, difference] =
          await checkBuildSize(path, cache_path);

        console.log(
          `Equal: ${isEqual
            .toString()
            .toUpperCase()} | Resource: ${resource_size} - Cache: ${cache_size} = Difference: ${difference}`
        );

        if (!isEqual) return buildTurbo(...args);

        cbt();
      })();
    },
  });

RegisterResourceBuildTaskFactory("turbo", () => buildTask);

on("onResourceStop", (resource) => {
  const build = built_resources[resource];
  if (build === undefined) return;
  if (build === true) return (built_resources[resource] = false);
});
