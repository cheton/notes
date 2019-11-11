## Articles

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

#### Import Maps
https://github.com/systemjs/systemjs#import-maps

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
