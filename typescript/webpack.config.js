const { sync } = require("glob"),
  { resolve } = require("path");

/**
 * @type {import("webpack").Configuration}
 */
const config = {
  entry: sync("./src/**/*.ts", { absolute: true, dot: true }).reduce(function (
    a,
    b
  ) {
    a[b.split("src\\")[1].replace(/(.ts)/g, "")] = b;
    return a;
  },
  {}),
  mode: "production",
  module: {
    rules: [{ test: /\.ts?$/, use: "ts-loader", exclude: /node_modules/ }],
  },
  output: {
    clean: true,
    filename: (pathData) => `${pathData.runtime.split("\\")[0]}/[contenthash].js`,
    path: resolve(__dirname, "dist"),
  },
  resolve: { extensions: [".ts"] },
};

module.exports = config;
