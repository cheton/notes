# Modules

## Index
1. [Overview](https://github.com/cheton/notes/blob/master/Modules.md#overview)
2. [Modules in JavaScript]()
3. [The basics of ES6 modules]()
4. [Importing and exporting in detail]()
5. [The ECMAScript 6 module loader API]()
6. [Using ES6 modules in browsers]()
7. [Details: imports as views on exports]()
8. [Design goals for ES6 modules]()
9. [FAQ: modules]

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
