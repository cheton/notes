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

#### Cyclic dependencines in CommonJS
a.js
```js
var b = require('b');
function foo() {
    b.bar();
}
exports.foo = foo;
```

b.js
```js
var a = require('a'); // (i): b cannot access a.foo in its top level
function bar() {
    if (Math.random()) {
        a.foo(); // (ii): If bar is called afterwards then the method call works
    }
}
exports.bar = bar;
```

#### Cyclic dependencines in ES6
a.js
```js
import {bar} from 'b'; // (i)
export function foo() {
    bar(); // (ii) it can work
}
```

b.js
```js
import {foo} from 'a'; // (iii)
export function bar() {
    if (Math.random()) {
        foo(); // (iv) it can work
    }
}
```

### Be cafeful with ES6 transpilers
ES6 transpilers such as Babel compile ES6 modules to ES5. Imports being views on exports is tricky to implement in plain JavaScript. But integrating legacy module systems is even harder. I therefore recommend to keep things simple and to be careful with the more exotic aspects of ES6 modules.

## Importing and exporting in detail

### Importing styles

* Default import:
  ```js
import localName from 'src/my_lib';
```

* Namespace import: imports the module as an object (with one property per named export)
  ```js
import * as my_lib from 'src/my_lib'; 
```

* Named imports:
  ```js
import { name1, name2 } from 'src/my_lib';
```
  You can rename named imports:
  ```js
// Renaming: import `name1` as `localName1`
import { name1 as localName1, name2 } from 'src/my_lib'; 
```

### Exporting styles: inline versus clause

#### Inline

```js
export var myVar1 = ···;
export let myVar2 = ···;
export const MY_CONST = ···;
export function myFunc() {
    ···
}
export function* myGeneratorFunc() {
    ···
}
export class MyClass {
    ···
}
```

```js
export default 123;
export default function (x) {
    return x
}
export default x => x;
export default class {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }
}
```

#### Clause
```js
const MY_CONST = ...;
function myFunc() {
   ...
}

export { MY_CONST, myFunc }
```

You can also export things under different names:
```js
export { MY_CONST as FOO, myFunc };
```

### Re-exporting

```js
 // Default exports are ignored by export *
export * from 'src/other_module';

// Selective exports
export { foo, bar } from 'src/other_module';

// Renaming: export other_module's foo as myFoo
export { foo as myFoo, bar } from 'src/other_module';

// Makes the default export of another module foo the default export of the current module
export { default } from 'foo';

// Makes the named export myFunc of module foo the default export of the current module
export { myFunc as default } from 'foo';
```

### All exporting styles

* Re-exporting:

  - Re-export everything (except for the default export):
    ```js
    export * from 'src/other_module';
    ```

  - Re-export via a clause:
    ```js
    export { foo as myFoo, bar } from 'src/other_module';
    ```

* Exporting via a clause:
  ```js
  export { MY_CONST as FOO, myFunc };
  ```

* Inline exports:

  - Variable declarations:
    ```js
    export var foo;
    export let foo;
    export const foo;
    ```
    
  - Function declarations:
    ```js
    export function myFunc() {}
    export function* myGenFunc() {}
    ```

  - Class declarations:
    ```js
    export class MyClass() {}
    ```

* Default export:

  - Function declarations (can be anonymous, but only here):
    ```js
    export default function myFunc() {}
    export default function () {}
    
    export default function* myGenFunc() {}
    export default function* () {}
    ```
  
  - Class declarations (can be anonymous, but only here):
    ```js
    export default class MyClass() {}
    export default class () {}
    ```
  
  - Expressions: export values. Note the semicolons at the end.
    ```js
    export default foo;
    export default 'Hello world!';
    export default 3 * 7;
    export default (function () {});
    ```

## The ES6 module loader API


## Using ES6 modules in browsers


## Details: imports as views on exports


## Design goals for ES6 modules


## FAQ: modules

