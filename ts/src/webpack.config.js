const glob = require("glob"),
  path = require("path"),
  webpack = require("webpack");

/**
 * @type {webpack.Configuration}
 */
const config = {
  entry: glob
    .sync("./resources/*/client/*.ts", { dot: true })
    .reduce(function (a, b) {
      a[b.split("resources/")[1].replace(/(.ts)/g, "")] = b;
      return a;
    }, {}),
  mode: "production",
  module: {
    rules: [{ test: /\.ts$/i, use: "ts-loader" }],
  },
  output: {
    chunkFilename: "[name].js",
    filename: "[name].js",
    path: path.join(__dirname, "../../resources/[ts]"),
  },
  resolve: {
    alias: {
      "@base": path.resolve("resources/base"),
    },
    extensions: [".ts"]
  },
};

module.exports = config;
