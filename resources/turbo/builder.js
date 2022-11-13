let progress = {
  building: false,
  module: "",
};

const { spawn } = require("child_process"),
  built_resources = [],
  buildTask = {
    shouldBuild: (resourceName) =>
      GetResourceMetadata(resourceName, "turbo_repo") === "yes" &&
      !built_resources.includes(resourceName),

    build(resourceName, cb) {
      (async function () {
        while (progress.building && progress.module !== resourceName) {
          await new Promise((resolve) => setTimeout(resolve, 5e3));
        }

        const path = `${GetResourcePath(resourceName)}`,
          cbf = cb.bind(this, false);

        if (!require("fs").existsSync(`${path}/turbo.json`))
          return cbf("[NOT FOUND] turbo.json");

        progress = {
          building: true,
          module: resourceName,
        };

        const process = spawn("npm", ["i"], { cwd: path, stdio: "pipe" })
          .on("spawn", () =>
            console.log(`[${resourceName}] installing packages...`)
          )
          .on("exit", function (code, signal) {
            setImmediate(function () {
              if (code !== 0 || signal) {
                resetProgress();
                return cb(false, "turbo failed!");
              }

              const process = spawn("npx", ["turbo", "build", "--no-daemon"], {
                cwd: path,
                stdio: "pipe",
              })
                .on("spawn", () => console.log(`[${resourceName}] building...`))
                .on("exit", function (code, signal) {
                  setImmediate(function () {
                    resetProgress();
                    if (code !== 0 || signal) return cb(false, "turbo failed.");
                    built_resources.push(resourceName);
                    cb(true);
                  });
                });

              process.stdout.on("data", (data) => console.log(data.toString()));
              process.stderr.on("data", (data) =>
                console.error(data.toString())
              );
            });

            function resetProgress() {
              progress = {
                building: false,
                module: "",
              };
            }
          });

        process.stdout.on("data", (data) => console.log(data.toString()));
        process.stderr.on("data", (data) => console.error(data.toString()));
      })();
    },
  };

RegisterResourceBuildTaskFactory("turbo", () => buildTask);
