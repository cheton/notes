# Migrating webpack to v5 from v4

⚠️ Remember to read the migration guide to see what has changed in webpack 5. ⚠️

https://webpack.js.org/migrate/5/


## Migration notes

### `process` is undefined

Starting from webpack 5, `process` is no longer defined and will cause runtime errors. To mitigate this issue, you have to ensure the existence of `process` and `process.env` objects before running webpack compiled JS bundles.

Add this script to your `index.html` before other scripts load:

```html
<script>
this.process = Object.assign({}, this.process, { env: {} });
</script>
```

### `resolve.fallback`

If you are using `node.something: 'empty'` replace it with `resolve.fallback.something: false`.

```js
{ // webpack.config.js
  resolve: {
    fallback: {
      fs: false,
      net: false,
      path: require.resolve('path-browserify'),
      stream: require.resolve('stream-browserify'),
      timers: require.resolve('timers-browserify'),
      tls: false,
    },
  },
}
```

- `fs`, `net`, `tls` are not supported under the `browser` environment
- `path`, `stream`, `timers` can be resolved by installing supported browserify packages
  ```sh
  npm i --save-dev path-browserify
  npm i --save-dev stream-browserify
  npm i --save-dev timers-browserify
  ```

### Deprecated plugins

* `CSSSplitWebpackPlugin` and `ManifestPlugin` are not supported in webpack 5
* `WriteFileWebpackPlugin` is no longer required when running with `webpack-dev-server`. The `devServer.writeToDisk` option is available for providing the same functionality.
  ```js
  devServer: {
    writeToDisk: true,
  }
  ```

### Other changes

* Replace `[hash]` with `[contenthash]`
* Replace `devtool: 'cheap-module-eval-source-map'` with `devtool: 'eval-cheap-module-source-map'`
* Replace `webpack-dev-server` with `webpack serve`
  ```
  cross-env NODE_ENV=development webpack serve --config webpack.config.development.js --inline --content-base output/app
  ```
* `devDependencies` in `package.json`

  ```diff
  +    "path-browserify": "~1.0.1",
  +    "stream-browserify": "~3.0.0",
  +    "timers-browserify": "~2.0.12",
  -    "webpack": "~4.44.2",
  -    "webpack-cli": "~3.3.12",
  +    "webpack": "~5.4.0",
  +    "webpack-cli": "~4.1.0",
  ```



## Diff files

### The diff result of `index.tmpl.html`

```diff
diff --git a/src/app/index.tmpl.html b/src/app/index.tmpl.html
index 8351e33b..bb55811c 100644
--- a/src/app/index.tmpl.html
+++ b/src/app/index.tmpl.html
@@ -11,6 +11,9 @@
 <link rel="shortcut icon" href="{{webroot}}favicon.ico">
 </head>
 <body>
+<script>
+this.process = Object.assign({}, this.process, { env: {} });
+</script>
 </body>
</html>
```

### The diff result of `webpack.config.development.js`

```diff
diff --git a/webpack.config.development.js b/webpack.config.development.js
index 28192744..5ab8d527 100644
--- a/webpack.config.development.js
+++ b/webpack.config.development.js
@@ -1,13 +1,10 @@
 const fs = require('fs');
 const path = require('path');
-const CSSSplitWebpackPlugin = require('css-split-webpack-plugin').default;
 const dotenv = require('dotenv');
 const HtmlWebpackPlugin = require('html-webpack-plugin');
 const without = require('lodash/without');
 const MiniCssExtractPlugin = require('mini-css-extract-plugin');
 const webpack = require('webpack');
-const ManifestPlugin = require('webpack-manifest-plugin');
-const WriteFileWebpackPlugin = require('write-file-webpack-plugin');
 const babelConfig = require('./babel.config');
 const buildConfig = require('./build.config');
 const pkg = require('./package.json');
@@ -23,10 +20,12 @@ const timestamp = new Date().getTime();

 module.exports = {
   mode: 'development',
-  cache: true,
+  cache: {
+    type: 'filesystem',
+  },
   target: 'web',
   context: path.resolve(__dirname, 'src/app'),
-  devtool: 'cheap-module-eval-source-map',
+  devtool: 'eval-cheap-module-source-map',
   entry: {
     polyfill: [
       path.resolve(__dirname, 'src/app/polyfill/index.js'),
@@ -40,7 +39,7 @@ module.exports = {
   output: {
     path: path.resolve(__dirname, 'output/cncjs/app'),
     chunkFilename: `[name].[chunkhash].chunk.js?_=${timestamp}`,
-    filename: `[name].[hash].bundle.js?_=${timestamp}`,
+    filename: `[name].[contenthash].bundle.js?_=${timestamp}`,
     pathinfo: true,
     publicPath: publicPath,
   },
@@ -133,45 +132,25 @@ module.exports = {
       },
     ].filter(Boolean),
   },
-  node: {
-    fs: 'empty',
-    net: 'empty',
-    tls: 'empty',
-  },
   plugins: [
     new webpack.HotModuleReplacementPlugin(),
-    new webpack.DefinePlugin({
-      'process.env': {
-        NODE_ENV: JSON.stringify('development'),
-        BUILD_VERSION: JSON.stringify(buildVersion),
-        LANGUAGES: JSON.stringify(buildConfig.languages),
-        TRACKING_ID: JSON.stringify(buildConfig.analytics.trackingId),
-      }
+    new webpack.EnvironmentPlugin({
+      NODE_ENV: JSON.stringify('development'),
+      BUILD_VERSION: JSON.stringify(buildVersion),
+      LANGUAGES: JSON.stringify(buildConfig.languages),
+      TRACKING_ID: JSON.stringify(buildConfig.analytics.trackingId),
     }),
     new webpack.LoaderOptionsPlugin({
       debug: true,
     }),
-    // https://github.com/gajus/write-file-webpack-plugin
-    // Forces webpack-dev-server to write bundle files to the file system.
-    new WriteFileWebpackPlugin(),
     new webpack.ContextReplacementPlugin(
       /moment[\/\\]locale$/,
       new RegExp('^\./(' + without(buildConfig.languages, 'en').join('|') + ')$'),
     ),
-    // Generates a manifest.json file in your root output directory with a mapping of all source file names to their corresponding output file.
-    new ManifestPlugin({
-      fileName: 'manifest.json',
-    }),
     new MiniCssExtractPlugin({
       filename: `[name].css?_=${timestamp}`,
       chunkFilename: `[id].css?_=${timestamp}`,
     }),
-    new CSSSplitWebpackPlugin({
-      size: 4000,
-      imports: '[name].[ext]?[hash]',
-      filename: '[name]-[part].[ext]?[hash]',
-      preserve: false,
-    }),
     // HtmlWebpackPlugin
     (() => {
       const filename = 'index.html';
@@ -203,11 +182,19 @@ module.exports = {
       'react-spring$': 'react-spring/web.cjs',
       'react-spring/renderprops$': 'react-spring/renderprops.cjs',
     },
+    extensions: ['.js', '.jsx'],
+    fallback: {
+      fs: false,
+      net: false,
+      path: require.resolve('path-browserify'),
+      stream: require.resolve('stream-browserify'),
+      timers: require.resolve('timers-browserify'),
+      tls: false,
+    },
     modules: [
       path.resolve(__dirname, 'src'),
       'node_modules',
     ],
-    extensions: ['.js', '.jsx'],
   },
   devServer: {
     host: process.env.WEBPACK_DEV_SERVER_HOST,
@@ -217,6 +204,7 @@ module.exports = {
     watchOptions: {
       ignored: /node_modules/,
     },
+    writeToDisk: true,
     proxy: {
       '/api': {
         target: process.env.PROXY_TARGET,
```


### The diff result of `webpack.config.production.js`

```diff
diff --git a/webpack.config.production.js b/webpack.config.production.js
index 821ff3f2..cefe7270 100644
--- a/webpack.config.production.js
+++ b/webpack.config.production.js
@@ -2,7 +2,6 @@ const crypto = require('crypto');
 const path = require('path');
 const { boolean } = require('boolean');
 const dotenv = require('dotenv');
-const CSSSplitWebpackPlugin = require('css-split-webpack-plugin').default;
 const findImports = require('find-imports');
 const HtmlWebpackPlugin = require('html-webpack-plugin');
 const without = require('lodash/without');
@@ -10,7 +9,6 @@ const MiniCssExtractPlugin = require('mini-css-extract-plugin');
 const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
 const TerserPlugin = require('terser-webpack-plugin');
 const webpack = require('webpack');
-const ManifestPlugin = require('webpack-manifest-plugin');
 const babelConfig = require('./babel.config');
 const buildConfig = require('./build.config');
 const pkg = require('./package.json');
@@ -35,7 +33,9 @@ const timestamp = new Date().getTime();

 module.exports = {
   mode: 'production',
-  cache: true,
+  cache: {
+    type: 'filesystem',
+  },
   target: 'web',
   context: path.resolve(__dirname, 'src/app'),
   devtool: 'cheap-module-source-map',
@@ -55,7 +55,7 @@ module.exports = {
   output: {
     path: path.resolve(__dirname, 'dist/cncjs/app'),
     chunkFilename: `[name].[chunkhash].chunk.js?_=${timestamp}`,
-    filename: `[name].[hash].bundle.js?_=${timestamp}`,
+    filename: `[name].[contenthash].bundle.js?_=${timestamp}`,
     publicPath: publicPath,
   },
   module: {
@@ -140,11 +140,6 @@ module.exports = {
       },
     ].filter(Boolean),
   },
-  node: {
-    fs: 'empty',
-    net: 'empty',
-    tls: 'empty',
-  },
   optimization: {
     minimizer: [
       USE_TERSER_PLUGIN && (
@@ -156,32 +151,20 @@ module.exports = {
     ].filter(Boolean)
   },
   plugins: [
-    new webpack.DefinePlugin({
-      'process.env': {
-        NODE_ENV: JSON.stringify('production'),
-        BUILD_VERSION: JSON.stringify(buildVersion),
-        LANGUAGES: JSON.stringify(buildConfig.languages),
-        TRACKING_ID: JSON.stringify(buildConfig.analytics.trackingId),
-      }
+    new webpack.EnvironmentPlugin({
+      NODE_ENV: JSON.stringify('production'),
+      BUILD_VERSION: JSON.stringify(buildVersion),
+      LANGUAGES: JSON.stringify(buildConfig.languages),
+      TRACKING_ID: JSON.stringify(buildConfig.analytics.trackingId),
     }),
     new webpack.ContextReplacementPlugin(
       /moment[\/\\]locale$/,
       new RegExp('^\./(' + without(buildConfig.languages, 'en').join('|') + ')$'),
     ),
-    // Generates a manifest.json file in your root output directory with a mapping of all source file names to their corresponding output file.
-    new ManifestPlugin({
-      fileName: 'manifest.json',
-    }),
     new MiniCssExtractPlugin({
       filename: `[name].css?_=${timestamp}`,
       chunkFilename: `[id].css?_=${timestamp}`,
     }),
-    new CSSSplitWebpackPlugin({
-      size: 4000,
-      imports: '[name].[ext]?[hash]',
-      filename: '[name]-[part].[ext]?[hash]',
-      preserve: false,
-    }),
     new HtmlWebpackPlugin({
       filename: 'index.html',
       template: path.resolve(__dirname, 'src/app/index.tmpl.html'),
@@ -192,10 +175,18 @@ module.exports = {
       'react-spring$': 'react-spring/web.cjs',
       'react-spring/renderprops$': 'react-spring/renderprops.cjs',
     },
+    extensions: ['.js', '.jsx'],
+    fallback: {
+      fs: false,
+      net: false,
+      path: require.resolve('path-browserify'),
+      stream: require.resolve('stream-browserify'),
+      timers: require.resolve('timers-browserify'),
+      tls: false,
+    },
     modules: [
       path.resolve(__dirname, 'src'),
       'node_modules',
     ],
-    extensions: ['.js', '.jsx'],
   },
 };
```
