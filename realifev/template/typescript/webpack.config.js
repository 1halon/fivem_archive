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
    a[b.split(/(src\/)|(src\\+)/g).reverse()[0].replace(/(.ts)/g, "")] = b;
    return a;
  },
  {}),
  mode: "production",
  module: {
    rules: [{ test: /\.ts?$/, use: "ts-loader", exclude: /node_modules/ }],
  },
  output: {
    clean: true,
    filename: (pathData) =>
      `${pathData.runtime.split(/(\/)|(\\+)/g).slice(0, -3)}/[contenthash].js`,
    path: resolve(__dirname, "dist"),
  },
  resolve: { extensions: [".ts"] },
};

module.exports = config;
