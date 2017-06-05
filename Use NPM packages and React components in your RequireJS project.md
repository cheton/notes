# Use NPM packages and React components in your RequireJS project

## 1. Use NPM packages in your RequireJS project

### RequireJS Project

#### [AMD] app.js
```js
define(function(require, exports, module) {

var $ = require('jquery');
var Backbone = require('backbone');
var _ = require('lodash');

var MyApp = Backbone.View.extend({
    events: {
    },
    render: function() {
    }
});

var view = new MyApp();

module.exports = {
    view: function() {
        return view;
    }
};

});
```

#### rjs.config.js
```js
define(function(require, exports, module) {

requirejs.config({
    paths: {  
        // Bower Components
        'lodash': 'bower_components/lodash/lodash',
        'backbone': 'bower_components/backbone/backbone',
        'jquery': 'bower_components/jquery/dist/jquery'
    },
    shim: {
        'lodash': {
            exports: '_'
        },
        'backbone': {
            // These script dependencies should be loaded before loading backbone.js
            deps: ['lodash', 'jquery'],
            // Once loaded, use the global 'Backbone' as the module value.
            exports: 'Backbone'
        },
        'jquery': {
            exports: '$'
        }
    }
});

});
```

### Package CommonJS modules in UMD format

#### webpack.config.umd.base.js
```js
const path = require('path');
const webpack = require('webpack');

const resolve = function(package) {
    const pkg = require(package + '/package.json');
    if (!pkg) {
        throw new Error('Failed to load ' + JSON.stringify(package + '/package.json'));
    }
    const file = pkg.browser || pkg.main || '';
    return path.resolve(__dirname, 'node_modules', package, file);
}

module.exports = {
    target: 'web',
    entry: {
        'classnames': resolve('classnames'),
        'detect-browser': resolve('detect-browser'),
        'escape-html': resolve('escape-html'),
        'html5-tag': resolve('html5-tag'),
        'infinite-tree': resolve('infinite-tree'),
        'universal-logger': resolve('universal-logger'),
        'universal-logger-browser': resolve('universal-logger-browser')
    },
    output: {
        path: path.resolve(__dirname, 'web/node_modules'),
        filename: '[name]/index.js',
        libraryTarget: 'umd'
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                loader: 'style-loader!css-loader'
            }
        ]
    },
    resolve: {
        modules: [
            path.resolve(__dirname, 'web'),
            'node_modules'
        ],
        extensions: ['.js', '.json', '.jsx', '.styl']
    }
};
```

#### webpack.config.umd.production.js
```js
const path = require('path');
const webpack = require('webpack');
const baseConfig = require('./webpack.config.umd.base');

module.exports = Object.assign({}, baseConfig, {
    devtool: 'sourcemap',
    plugins: [
        new webpack.DefinePlugin({
            'process.env': {
                // This has effect on the react lib size
                NODE_ENV: JSON.stringify('production')
            }
        }),
        new webpack.NoEmitOnErrorsPlugin(),
        new webpack.optimize.CommonsChunkPlugin({
            names: ['webpack-bootstrap'],
            filename: '[name]/index.js',
            minChunks: Infinity
        })
    ]
});
```

### Add packaged modules to RequireJS config file

#### rjs.config.js
```js
define(function(require, exports, module) {

requirejs.config({
    paths: {
        // NPM packages
        'webpack-bootstrap': 'node_modules/webpack-bootstrap/index',
        'classnames': 'node_modules/classnames/index',
        'detect-browser': 'node_modules/detect-browser/index',
        'escape-html': 'node_modules/escape-html/index',
        'html5-tag': 'node_modules/html5-tag/index',
        'infinite-tree': 'node_modules/infinite-tree/index',
        'universal-logger': 'node_modules/universal-logger/index',
        'universal-logger-browser': 'node_modules/universal-logger-browser/index',

        // Bower Components
        'lodash': 'bower_components/lodash/lodash',
        'backbone': 'bower_components/backbone/backbone',
        'jquery': 'bower_components/jquery/dist/jquery'
    },
    shim: {
        'lodash': {
            exports: '_'
        },
        'backbone': {
            // These script dependencies should be loaded before loading backbone.js
            deps: ['lodash', 'jquery'],
            // Once loaded, use the global 'Backbone' as the module value.
            exports: 'Backbone'
        },
        'jquery': {
            exports: '$'
        }
    }
});

});
```

#### [AMD] tree.js
```js
define(function(require, exports, module) {

var InfiniteTree = require('infinite-tree');

var el = document.querySelector('#treeview');
var tree = new InfiniteTree(el, {
});

module.exports = tree;

});
```

## 2. Use React components in your RequireJS project

### React Project

#### index.js
```js
/* eslint import/no-dynamic-require: 0 */
/* eslint import/first: 0 */
require('./polyfill');

import reduce from 'lodash/reduce';
import async from 'async';
import Uri from 'jsuri';
import i18next from 'i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import XHR from 'i18next-xhr-backend';
import moment from 'moment';
import React from 'react';
import { Provider } from 'react-redux';
import { TRACE, DEBUG, INFO, WARN, ERROR } from 'universal-logger';
import configureStore from './store/configureStore';
import settings from './config/settings';
import log from './lib/log';

const store = configureStore();

//import './styles/vendor.styl';
//import './styles/app.styl';

const queryparams = ((qs) => {
    qs = String(qs || '');
    if (qs[0] !== '?') {
        qs = '?' + qs;
    }
    let uri = new Uri(qs);
    let obj = reduce(uri.queryPairs, (obj, item) => {
        let key = item[0], value = item[1];
        obj[key] = decodeURIComponent(value);
        return obj;
    }, {});

    return obj;
})(window.location.search) || {};

async.series([
    (next) => {
        const level = {
            trace: TRACE,
            debug: DEBUG,
            info: INFO,
            warn: WARN,
            error: ERROR
        }[queryparams.log_level || settings.log.level];
        log.setLevel(level);

        let msg = [
            'version=' + settings.version,
            'webroot=' + settings.webroot,
            'cdn=' + settings.cdn
        ];
        log.info(msg.join(','));

        next();
    },
    (next) => {
        i18next
            .use(XHR)
            .use(LanguageDetector)
            .init(settings.i18next, (t) => {
                next();
            });
    },
    (next) => {
        const lng = i18next.language;
        if (lng === 'en') {
            next();
            return;
        }

        require('bundle-loader!moment/locale/' + lng)(() => {
            log.debug(`moment: lng=${lng}`);
            moment().locale(lng);
            next();
        });
    }
], (err, results) => {
    { // Prevent browser from loading a drag-and-dropped file
      // http://stackoverflow.com/questions/6756583/prevent-browser-from-loading-a-drag-and-dropped-file
        window.addEventListener('dragover', (e) => {
            e = e || event;
            e.preventDefault();
        }, false);

        window.addEventListener('drop', (e) => {
            e = e || event;
            e.preventDefault();
        }, false);
    }
});

const connect = (Component) => (props) => (
    <Provider store={store}>
        <Component {...props} />
    </Provider>
);

const fetch = (name) => new Promise((resolve, reject) => {
    const fn = {
        'containers/Todo': () => {
            require.ensure([], (require) => {
                const Component = require('./containers/Todo').default;
                resolve(connect(Component));
            });
        }
    }[name];

    if (typeof fn !== 'function') {
        const err = new Error('Component is undefined:', name);
        reject(err);
        return;
    }

    fn();
});

module.exports = {
    fetch
};
```

#### webpack.config.production.js
```js
const without = require('lodash/without');
const path = require('path');
const webpack = require('webpack');
const findImports = require('find-imports');
const stylusLoader = require('stylus-loader');
const nib = require('nib');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const languages = [
    'en', // default
    'de',
    'es',
    'fr',
    'it',
    'ja',
    'zh-cn'
];
const publicPath = 'node_modules/rmx-webapp/';

module.exports = {
    cache: true,
    devtool: 'source-map',
    target: 'web',
    entry: path.resolve(__dirname, 'src/web/index.js'),
    output: {
        path: path.join(__dirname, 'output/web'),
        filename: 'index.js',
        libraryTarget: 'umd',
        publicPath: publicPath
    },
    externals: {
        'react': {
            root: 'React',
            commonjs2: 'react',
            commonjs: 'react',
            amd: 'react'
        },
        'react-dom': {
            root: 'ReactDOM',
            commonjs2: 'react-dom',
            commonjs: 'react-dom',
            amd: 'react-dom'
        }
    },
    module: {
        rules: [
            // http://survivejs.com/webpack_react/linting_in_webpack/
            {
                test: /\.jsx?$/,
                loader: 'eslint-loader',
                enforce: 'pre',
                exclude: /node_modules/
            },
            {
                test: /\.styl$/,
                loader: 'stylint-loader',
                enforce: 'pre'
            },
            {
                test: /\.jsx?$/,
                loader: 'babel-loader',
                exclude: /(node_modules|bower_components)/
            },
            {
                test: /\.styl$/,
                use: [
                    'style-loader',
                    'css-loader?camelCase&modules&importLoaders=1&localIdentName=[local]---[hash:base64:5]',
                    'stylus-loader'
                ]
            },
            {
                test: /\.css$/,
                loader: 'style-loader!css-loader'
            },
            {
                test: /\.(png|jpg|svg|cur)$/,
                loader: 'url-loader'
            }
        ]
    },
    plugins: [
        new webpack.DefinePlugin({
            'process.env': {
                // This has effect on the react lib size
                NODE_ENV: JSON.stringify('production')
            }
        }),
        new webpack.NoEmitOnErrorsPlugin(),
        new stylusLoader.OptionsPlugin({
            default: {
                // nib - CSS3 extensions for Stylus
                use: [nib()],
                // no need to have a '@import "nib"' in the stylesheet
                import: ['~nib/lib/nib/index.styl']
            }
        }),
        new webpack.ContextReplacementPlugin(
            /moment[\/\\]locale$/,
            new RegExp('^\./(' + without(languages, 'en').join('|') + ')$')
        ),
        new webpack.optimize.UglifyJsPlugin({
            sourceMap: true,
            compress: {
                screw_ie8: true, // React doesn't support IE8
                warnings: false
            },
            mangle: {
                screw_ie8: true
            },
            output: {
                comments: false,
                screw_ie8: true
            }
        })
    ],
    resolve: {
        modules: [
            path.resolve(__dirname, 'src/web'),
            'node_modules'
        ],
        extensions: ['.js', '.json', '.jsx', '.styl']
    }
};
```

***

### RequireJS Project

#### rjs.config.js
```js
define(function(require, exports, module) {

requirejs.config({
    paths: {
        // React components
        'rmx-webapp': 'node_modules/rmx-webap/index',

        // Bower components
        'react': 'bower_components/react/react',
        'react-dom': 'bower_components/react/react-dom'
    }
});

});
```

#### [AMD] main.js
```js
define(function(require, exports, module) {

var webapp = require('rmx-webapp');
var React = require('react');
var ReactDOM = require('react-dom');

webapp.fetch('containers/Todo')
    .then(function(Component) {
        var el = document.querySelector('#viewport');
        var props = {
            title: 'Todo',
            onUpdate: function() {
                // TODO
            }
        };
        ReactDOM.render(React.createElement(Component, props), el);
    });

});
```
