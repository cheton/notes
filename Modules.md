# Modules

## Index
1. [Overview](https://github.com/cheton/notes/blob/master/Modules.md#1-overview)
2. [Modules in JavaScript](https://github.com/cheton/notes/blob/master/Modules.md#2-modules-in-javascript)
3. [The basics of ES6 modules](https://github.com/cheton/notes/blob/master/Modules.md#3-the-basics-of-es6-modules)
4. [Importing and exporting in detail](https://github.com/cheton/notes/blob/master/Modules.md#4-importing-and-exporting-in-detail)
5. [The ES6 module loader API](https://github.com/cheton/notes/blob/master/Modules.md#5-the-es6-module-loader-api)
6. [Using ES6 modules in browsers](https://github.com/cheton/notes/blob/master/Modules.md#6-using-es6-modules-in-browsers)
7. [Details: imports as views on exports](https://github.com/cheton/notes/blob/master/Modules.md#7-details-imports-as-views-on-exports)
8. [Design goals for ES6 modules](https://github.com/cheton/notes/blob/master/Modules.md#8-design-goals-for-es6-modules)
9. [FAQ: modules](https://github.com/cheton/notes/blob/master/Modules.md#9-faq-modules)
10. [Benefits of ES6 modules](https://github.com/cheton/notes/blob/master/Modules.md#10-benefits-of-es6-modules)

## 1. Overview

### Multiple named exports

<i>lib.js</i>
```js
export const sqrt = Math.sqrt;
export function square(x) {
  return x * x;
}
export function diag(x, y) {
  return sqrt(square(x) + square(y));
}
```

<i>main.js</i>
```js
import { square, diag } from 'lib';
console.log(square(11)); // 121
console.log(diag(4, 3)); // 5
```

### Single default export

<i>myFunc.js</i>
```js
export default function () { ··· } // no semicolon!
```

<i>MyClass.js</i>
```js
export default class { ··· } // no semicolon!
```

<i>main1.js</i>
```js
import myFunc from 'myFunc';
myFunc();
```

<i>main2.js</i>
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


## 2. Modules in JavaScript

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

## 3. The basics of ES6 modules

### Named exports (several per module)
<i>lib.js</i>
```js
export const sqrt = Math.sqrt;
export function square(x) {
    return x * x;
}
export function diag(x, y) {
    return sqrt(square(x) + square(y));
}
```

<i>main.js</i>
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
<i>myFunc.js</i>
```js
export default function () { ··· } // no semicolon!
```

<i>MyClass.js</i>
```js
export default class { ··· } // no semicolon!
```

<i>main1.js</i>
```js
import myFunc from 'myFunc';
myFunc();
```

<i>main2.js</i>
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

<i>lib.js</i>
```js
export let counter = 3;
export function incCounter() {
    counter++;
}
```

<i>main.js</i>
```js
import { counter, incCounter } from './lib';

// The imported value `counter` is live
console.log(counter); // 3
incCounter();
console.log(counter); // 4
```

### Support for cyclic dependencies

#### Cyclic dependencines in CommonJS

<i>a.js</i>
```js
var b = require('b');
function foo() {
    b.bar();
}
exports.foo = foo;
```

<i>b.js</i>
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

<i>a.js</i>
```js
import {bar} from 'b'; // (i)
export function foo() {
    bar(); // (ii) it can work
}
```

<i>b.js</i>
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

## 4. Importing and exporting in detail

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
export default from 'foo';

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

### Named exports and a default export in a module

The pattern is surprisingly common in JavaScript: A library is a single function, but additional services are provided via properties of that function. Examples include jQuery, Underscore.js, and React.

<i>underscore.js</i>
```js
export default function (obj) {
    ···
}
export function each(obj, iterator, context) {
    ···
}
export { each as forEach };
```

<i>main.js</i>
```js
import _, { each } from 'underscore';
```

#### The default export is just another named export

The following two statements are equivalent:
```js
import { default as foo } from 'lib'; 
import foo from 'lib';
```

The following two modules have the same default export:

<i>module1.js</i>
```js
export default function foo() {} // function declaration!
```

<i>module2.js</i>
```js
function foo() {}
export { foo as default };
```

## 5. The ES6 module loader API

In addition to the declarative syntax for working with modules, there is also a programmatic API that allows you to:
* Programmatically work with modules
* Configure module loading


### Loader method: importing modules

You can progtammatically import a module, via an API based on Promises:
```js
import { System } from 'es6-module-loader';

System.import('some_module')
    .then(some_module => {
        // Use some_module
    })
    .catch(error => {
    });
```

`System.import` retrieves a single module, you can use `Promise.all()` to import several modules:
```js
Promise.all(['module1', 'module2', 'module3'].map(x => System.import(x)))
    .then(([module1, module2, module3]) => {
        // Use module1, module2, module3
    });
```

### More loader methods

Loaders have more methods. Three important ones are:
* `System.module(source, options)` evaluates the JavaScript code in source to a module.
* `System.set(name, module)` is for registering a module.
* `System.define(name, source, options)` both evaluates the module code in source and registers the result.

## 6. Using ES6 modules in browsers

An overview of the differences:

|                                              | Scripts        | Modules                      |
|----------------------------------------------|----------------|------------------------------|
| HTML element                                 | &lt;script&gt; | &lt;script type="module"&gt; |
| Top-level variables are                      | global         | local to module              |
| Value of `this` at top level                 | `window`       | `undefined`                  |
| Executed                                     | synchronously  | asynchronously               |
| Import declaratively (`import` statement)    | no             | yes                          |
| Import programmatically (Promised-based API) | yes            | yes                          |
| File extension                               | `.js`          | `.js`                        |

### Scripts

Scripts are normally loaded or executed synchronously.

```html
<script type="text/javascript">
</script>
```

For HTML5, the recommendation is to omit the `type` attribute in `<script>` element.

### Modules

https://github.com/ModuleLoader/es6-module-loader

There are two options for importing modules:
* Node.js
  Load modules synchronously, while the body is executed. 
* AMD modules
  Load all modules asynchronously, before the body is executed. It's the best option for browsers, because modules are loaded over the Internet.

ES6 gives you the best of both worlds: The synchronous syntax of Node.js plus the asynchronous loading of AMD. To make both possible, ES6 modules syntactically less flexible than Node.js modules: Imports and exports must happen at the top level. They can't be conditional, either.

Modules can be used from browsers via a new variant of the `<script>` element that is completely asynchronous:
```html
<script type="module">
import $ from 'lib/jquery';
var x = 123;

// The current scope is not global
console.log('$' in window); // false
console.log('x' in window); // false

// `this` still refers to the global object
console.log(this === window); // true
</script>
```

### Bundling

* HTTP/2: will allow multiple requests per TCP connection, which makes bundling unnecessary. You can then incrementally update your application, because if a single module changes, browsers don't have to download the complete bundle, again.

* Packages: Additionally, W3C is working on a standard for "Packaging on the Web". The idea is to put a whole directory into a package. Then this package URL:
  ```
  http://example.org/downloads/editor.pack#url=/root.html;fragment=colophon
  ```
  is equivalent to the following normal URL, if the package were unpacked into the root of the web server:
  ```
  http://example.org/downloads/root.html#colophon
  ```

## 7. Details: imports as views on exports

Imports work differently in CommonJS and ES6:
* In CommonJS, imports are copies of exported values.
* In ES6, imports are live read-only views on exported values.

### CommonJS - imports are copies of exported values

<i>lib.js</i>
```js
var counter = 3;
function incCounter() {
    counter++;
}
module.exports = {
    counter: counter, // (A)
    incCounter: incCounter
};
```

<i>main1.js</i>
```js
var counter = require('./lib').counter; // (B)
var incCounter = require('./lib').incCounter;

// The imported value is a (disconnected) copy
console.log(counter); // 3
incCounter();
console.log(counter); // 3

// The imported value can be changed
counter++;
console.log(counter); // 4
```

If you access the value via the exports object, it is still copied once, on export:

<i>main2.js</i>
```js
var lib = require('./lib');

// The imported value is a (disconnected) copy
console.log(lib.counter); // 3
lib.incCounter();
console.log(lib.counter); // 3

// The imported value can be changed
lib.counter++;
console.log(lib.counter); // 4
```

### ES6 - imports are live read-only views on exported values

The following code demostrates how imports are like views:

<i>lib.js</i>
```js
export let counter = 3;
export function incCounter() {
    counter++;
}
```

<i>main1.js</i>
```js
import { counter, incCounter } from './lib';

// The imported value `counter` is live
console.log(counter); // 3
incCounter();
console.log(counter); // 4

// The imported value can’t be changed
counter++; // TypeError
```

If you import the module object via the asterisk (*), you get the same results:

<i>main2.js</i>
```js
import * as lib from './lib';

// The imported value `counter` is live
console.log(lib.counter); // 3
lib.incCounter();
console.log(lib.counter); // 4
// The imported value can’t be changed
lib.counter++; // TypeError
```

Note that while you can't change the values of imports, you can change the objects that they are referring to. For example:

<i>lib.js</i>
```js
export let obj = {};
```

<i>main.js</i>
```js
import { obj } from './lib';

obj.prop = 123; // OK
obj = {}; // TypeError
```

## 8. Design goals for ES6 modules

### 1. Default exports are favored

### 2. Static module structure

In current JavaScript module systems, you have to execute the code in order to find out what the imports and exports are.

In this example, you have to run the code to find out what it imports:
```js
var my_lib;
if (Math.random()) {
    my_lib = require('foo');
} else {
    my_lib = require('bar');
}
```

In this example, you have to run the code to find out what it exports:
```js
if (Math.random()) {
    exports.baz = ···;
}
```

ES6 gives you less flexibility, it forces you to be static. As a result, you get several benefits, including:
- faster lookup
- variable checking
- ready for macros
- ready for types
- supporting other languages

### 3. Support for synchronous and asynchronous loading

ES6 syntax is well suited for synchronous loading, asynchronous loading is enabled by its static structure: Because you can statically determine all imports, and load them before evaluating the body of the module.

### 4. Support for cyclic dependencies between modules

Cyclic dependencies are not inherently evil. Especially for objects, you sometimes even want this kind of dependency. For example, in some trees likes DOM documents, parents refer to children and children refer back to parents.

## 9. FAQ: modules

### 1. Can I use a variable to specify from which module I want to import?

Use the programmatic loader API if you want to dynamically determine what module to load:
```js
let moduleSpecifier = 'module_' + Math.random();
System.import(moduleSpecifier)
    .then(the_module => {
        // Use the_module
    });
```

### 2. Can I import a module conditionally or on demand?

Use the programmatic loader API if you want to load a module conditionally or on demand:
```js
if (Math.random()) {
    System.import('some_module')
        .then(some_module => {
            // Use some_module
        })
}
```

### 3. Can I use destructuring in an import statement?

No you can't. You cannot do something like this in an ES6 module:
```js
var bar = require('some_module').foo.bar;
```

### 4. Are named exports necessary? Why not default-export objects?

You can't enfore a static structure via objects and lose all of the associated advantages:
```js
export default {
    foo: 1,
    bar: 2
};
```

### 5. Can I eval() modules?

No, you can't. Syntactically, `eval()` accepts scripts, not modules.

## 10. Benefits of ES6 modules

* No more [UMD (Universal Module Definition)](https://github.com/umdjs/umd): UMD is a name for patterns that enable the same file to be used by several module systems (e.g. both CommonJS and AMD). Once ES6 is the only module standard, UMD becomes obsolete.
  ```js
  (function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['exports', 'b'], function (exports, b) {
            factory((root.commonJsStrictGlobal = exports), b);
        });
    } else if (typeof exports === 'object' && typeof exports.nodeName !== 'string') {
        // CommonJS
        factory(exports, require('b'));
    } else {
        // Browser globals
        factory((root.commonJsStrictGlobal = {}), root.b);
    }
  }(this, function (exports, b) {
    //use b in some fashion.

    // attach properties to the exports object to define
    // the exported module properties.
    exports.action = function () {};
  }));
  ```

* New browser APIs become modules instead of global variables or properties of `navigator`. For example:
  ```js
  import navigator from 'navigator';
  ```

* No more objects-as-namespaces: Objects such as Math and JSON serve as namespaces for functions in ES5. In the future, such functionality can be provided via modules.
