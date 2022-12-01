// DEPRECATED

(function (__resource, excludedDirs, progress) {
  const { spawn } = require("child_process"),
    { createWriteStream, existsSync, statSync, mkdirSync } = require("fs"),
    { readdir, readFile } = require("fs/promises"),
    { join, dirname } = require("path");

  const dirSize = async (path) => {
      if (!existsSync(path)) return 0;

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
    },
    write = (path, size) => {
      if (!existsSync(path)) mkdirSync(dirname(path), { recursive: true });
      createWriteStream(path, {
        flags: "w+",
      }).end(String(size));
    },
    readSize = async (cache_path) =>
      Number(await readFile(cache_path).catch(() => 0)),
    buildTurbo = (path, resourceName, progress, cbf, cbt, cache_path) => {
      const process = spawn("npx", ["turbo", "build", "--no-daemon"], {
        cwd: path,
        stdio: "pipe",
      })
        .on("spawn", () => console.log(`[${resourceName}] building...`))
        .on("exit", function (code, signal) {
          setImmediate(async function () {
            progress.reset();
            if (code !== 0 || signal) return cbf("build failed.");

            write(cache_path, await dirSize(path));
            write(
              cache_path.replace("size", "package_size"),
              statSync(`${path}/package.json`).size
            );

            src_sizes[resourceName] = {
              interval: setInterval(async function () {
                const self = src_sizes[resourceName];

                if ((await dirSize(`${path}/src`)) !== self.size) {
                  clearInterval(self.interval);

                  self.interval = settimeout();
                  self.log();

                  function settimeout() {
                    setTimeout(timeout, self.timeout * 1e3);
                  }

                  function timeout() {
                    self.timeout *= 1.5;
                    if (self.timeout > 90) self.timeout = 90;
                    self.interval = settimeout();
                    self.log();
                  }
                }
              }, 5 * 1e3),
              log: () =>
                console.log(
                  `[${resourceName}] Change(s) detected in source files. Use 'restart ${resourceName}' to apply change(s).`
                ),
              size: await dirSize(`${path}/src`),
              timeout: 5,
            };

            cbt();
          });
        });

      process.stdout.on("data", (data) => console.log(data.toString()));
      process.stderr.on("data", (data) => console.error(data.toString()));
    },
    installPackages = (path, resourceName, progress, cbf, ...args) => {
      const process = spawn("npm", ["i"], { cwd: path, stdio: "pipe" })
        .on("spawn", () =>
          console.log(`[${resourceName}] installing packages...`)
        )
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

  let progress = {
    building: false,
    module: null,
    reset() {
      this.building = false;
      this.module = null;
    },
  };

  const built_resources = {},
    src_sizes = {},
    buildTask = {
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
              (await readSize(cache_path.replace("size", "package_size")))
          )
            return installPackages(...args);

          const resource_size = await dirSize(path),
            cache_size = await readSize(),
            isEqual = resource_size === cache_size;

          console.log(
            `Equal: ${isEqual
              .toString()
              .toUpperCase()} | Resource: ${resource_size} - Cache: ${cache_size} = Difference: ${
              resource_size - cache_size
            }`
          );

          if (!isEqual) return buildTurbo(...args);

          cbt();
        })();
      },
    };

  RegisterResourceBuildTaskFactory("turbo", () => buildTask);

  on("onResourceStop", (resource) => {
    built_resources[resource] === true && delete built_resources[resource];
    src_sizes[resource] &&
      clearInterval(src_sizes[resource].interval) &&
      delete src_sizes[resource];
  });
})(GetCurrentResourceName(), [".turbo", "node_modules"], {
  building: false,
  module: null,
  reset() {
    this.building = false;
    this.module = null;
  },
});
