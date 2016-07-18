# Modules

## Index
1. [Overview](https://github.com/cheton/notes/blob/master/Modules.md#overview)
2. [Modules in JavaScript]()
3. [The basics of ES6 modules]()
4. [Importing and exporting in detail]()
5. [The ES6 module loader API]()
6. [Using ES6 modules in browsers]()
7. [Details: imports as views on exports]()
8. [Design goals for ES6 modules]()
9. [FAQ: modules]()

## Overview

### Multiple named exports

lib.js
```js
export const sqrt = Math.sqrt;
export function square(x) {
  return x * x;
}
export function diag(x, y) {
  return sqrt(square(x) + square(y));
}
```

main.js
```js
import { square, diag } from 'lib';
console.log(square(11)); // 121
console.log(diag(4, 3)); // 5
```

### Single default export
myFunc.js
```js
export default function () { ··· } // no semicolon!
```

main1.js
```js
import myFunc from 'myFunc';
myFunc();
```

or a class

MyClass.js
```js
export default class { ··· } // no semicolon!
```

main2.js
```js
import MyClass from 'MyClass';
let inst = new MyClass();
```

### Browsers: scripts versus modules
|                                              | Scripts        | Modules                      |
|----------------------------------------------|----------------|------------------------------|
| HTML element                                 | &lt;script&gt; | &lt;script type="module"&gt; |
| Top-level variables are                      | global         | local to module              |
| Value of `this` at top level                 | `window`       | `undefined`                  |
| Executed                                     | synchronously  | asynchronously               |
| Import declaratively (`import` statement)    | no             | yes                          |
| Import programmatically (Promised-based API) | yes            | yes                          |
| File extension                               | `.js`          | `.js`                        |


## Modules in JavaScript

### ES5 modules
* CommonJS modules: Node.js
  - Compact syntax
  - Designed for synchronous loading
  - Main use: server
* Asynchronous Module Definition (AMD): RequireJS
  - Slightly more complicated syntax
  - Designed for asynchronous loading
  - Main use: browsers

### ES6 modules

The goal for ES6 modules was to create a format that both users of CommonJS and of AMD are happy with:
* Similarly to CommonJS: compact syntax, prefer single exports, and support for cyclic dependencies
* Similarly to AMD: direct support for asynchronous loading and configurable module loading 

The ES6 module standard has two parts:
* Declarative syntax (for importing and exporting)
* Programmatic loader API: to configure how modules are loaded and to conditionally load modules

## The basics of ES6 modules


## Importing and exporting in detail


## The ES6 module loader API


## Using ES6 modules in browsers


## Details: imports as views on exports


## Design goals for ES6 modules


## FAQ: modules

