# Modules

## Index
1. [Overview](https://github.com/cheton/notes/blob/master/Modules.md#overview)
2. [Modules in JavaScript](https://github.com/cheton/notes/blob/master/Modules.md#modules-in-javascript)
3. [The basics of ES6 modules](https://github.com/cheton/notes/blob/master/Modules.md#the-basics-of-es6-modules)
4. [Importing and exporting in detail](https://github.com/cheton/notes/blob/master/Modules.md#importing-and-exporting-in-detail)
5. [The ES6 module loader API](https://github.com/cheton/notes/blob/master/Modules.md#the-es6-module-loader-api)
6. [Using ES6 modules in browsers](https://github.com/cheton/notes/blob/master/Modules.md#using-es6-module-in-browsers)
7. [Details: imports as views on exports](https://github.com/cheton/notes/blob/master/Modules.md#details:-imports-as-views-on-exports)
8. [Design goals for ES6 modules](https://github.com/cheton/notes/blob/master/Modules.md#design-goals-for-es6-modules)
9. [FAQ: modules](https://github.com/cheton/notes/blob/master/Modules.md#faq:-modules)

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

MyClass.js
```js
export default class { ··· } // no semicolon!
```

main1.js
```js
import myFunc from 'myFunc';
myFunc();
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

### Named exports (several per module)
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

You can also import the whole module and refer to its named exports via property notation:
```js
import * as lib from 'lib';
console.log(lib.square(11)); // 121
console.log(lib.diag(4, 3)); // 5
```

### Default exports (one per module)
myFunc.js
```js
export default function () { ··· } // no semicolon!
```

MyClass.js
```js
export default class { ··· } // no semicolon!
```

main1.js
```js
import myFunc from 'myFunc';
myFunc();
```

main2.js
```js
import MyClass from 'MyClass';
let inst = new MyClass();
```

There are two styles of default exports:

#### Labels for declarations
```js
export default function foo() {} // no semicolon!
export default class Bar {} // no semicolon!
export default function () {} // no semicolon!
export default class {} // no semicolon!
```

#### Direct exports of values (produced by expressions)
The values are produced via expressions:
```js
export default 'abc';
export default foo();
export default /^xyz$/;
export default { no: false, yes: true };
export default 5 * 7;
```

Each of these default exports has the following structure:
```js
export default «expression»;
```

That is equivalent to:
```js
const __default__ = «expression»;
export { __default__ as default };
```

### Imports are hoisted
Module imports are hoisted (internally moved to the beginning of the current scope):
```js
foo();
import { foo } from 'my_module';
```

### Imports are read-only views on exports
lib.js
```js
export let counter = 3;
export function incCounter() {
    counter++;
}
```

main.js
```js
import { counter, incCounter } from './lib';

// The imported value `counter` is live
console.log(counter); // 3
incCounter();
console.log(counter); // 4
```

### Support for cyclic dependencies
CommonJS:


## Importing and exporting in detail


## The ES6 module loader API


## Using ES6 modules in browsers


## Details: imports as views on exports


## Design goals for ES6 modules


## FAQ: modules

