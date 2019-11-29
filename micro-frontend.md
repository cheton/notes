## Articles

### Micro-frontend Architecture in Action-微前端的那些事儿 
https://microfrontends.cn/
https://github.com/phodal/microfrontends

#### 一起探討 Micro Frontends 的世界
https://blog.techbridge.cc/2019/01/12/micro-frontends-concept/

#### 微前端 - 将微服务理念扩展到前端开发
https://lecture.jimmylv.info/2017-12-22-tech-radar-microfrontends-extending-microservice-to-fed.html#0

#### 技术雷达之「微前端」- 将微服务理念扩展到前端开发（上：理论篇）
https://blog.jimmylv.info/2017-12-22-tech-radar-microfrontends-extending-microservice-to-fed/

#### 技术雷达之「微前端」- 将微服务理念扩展到前端开发（下：实战篇）
https://blog.jimmylv.info/2017-12-24-tech-radar-microfrontends-extending-microservice-to-fed-next/

#### Micro Frontends Proof of Concept
https://github.com/Pragmatists/microfrontends

## Single SPA

#### Portal Example
https://gitlab.com/TheMcMurder/single-spa-portal-example/blob/master/src/index.html

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <title></title>
  </head>
  <body>

    <script type="systemjs-importmap">
      {
        "imports": {
          "@portal/config": "http://localhost:8233/config.js",
          "@portal/navbar": "http://localhost:8235/navbar.js",
          "@portal/people": "http://localhost:8236/people.js",
          "@portal/planets": "http://localhost:8237/planets.js",
          "@portal/fetchWithCache": "http://localhost:8238/fetchWithCache.js"
        }
      }
    </script>
    <script src='https://unpkg.com/systemjs@4.1.0/dist/system.js'></script>
    <script src='https://unpkg.com/systemjs@4.1.0/dist/extras/amd.js'></script>
    <script src='https://unpkg.com/systemjs@4.1.0/dist/extras/named-exports.js'></script>
    <script src='https://unpkg.com/systemjs@4.1.0/dist/extras/use-default.js'></script>

    <!-- Load the common deps-->
    <script src="http://localhost:8234/common-deps.js"></script>

    <!-- Load the application -->
    <script>
      System.import('@portal/config')
    </script>

    <!-- Static navbar -->
    <link rel="stylesheet" href="http://localhost:8233/styles.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
    <div id='navbar'>
    </div>

  </body>
</html>
```

#### Import Maps
https://github.com/systemjs/systemjs#import-maps

```js
<script src="system.js"></script>
<script type="systemjs-importmap">
{
  "imports": {
    "lodash": "https://unpkg.com/lodash@4.17.10/lodash.js"
  }
}
</script>
<!-- Alternatively:
<script type="systemjs-importmap" src="path/to/map.json">
-->
<script>
  System.import('/js/main.js');
</script>
```

#### Webpack Config
https://github.com/joeldenning/systemjs-webpack-interop#checkwebpackconfig

```js
// webpack.config.js
const systemjsInterop = require("systemjs-webpack-interop");

// Pass in your webpack config, and systemjs-webpack-interop will make it
// work better with SystemJS
module.exports = {
  output: {
    libraryTarget: "system"
  },
  module: {
    rules: [{ parser: { system: false } }]
  }
};

// Throws errors if your webpack config won't interop well with SystemJS
systemjsInterop.checkWebpackConfig(module.exports);
```
