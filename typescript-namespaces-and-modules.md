# TypeScript: Namespaces and Modules
#### Modules
https://www.typescriptlang.org/docs/handbook/modules.html

#### Namespaces
https://www.typescriptlang.org/docs/handbook/namespaces.html

## Terminology
In TypeScript 1.5, the nomenclature has changed to align with ECMAScript 2015's terminology.

* Internal modules are now **namespaces**
  - `module X {` is equivalent to the now-preferred `namespace X {`
* External modules are now simply **modules**

## Using Namespaces
* Namespaces are simply named JavaScript objects in the global namespace (e.g. jQuery plugins).
* They can span multiple files, and can be concatenated using `--outFile`.
* It can be a good way to structure your code in a Web Application, with all dependencies included as `<script>` tags in your HTML page.
* It can be hard to identify component dependencies (i.e. global namespace pollution), especially in a large application.

_Validation.ts_
```ts
namespace Validation {
    export interface StringValidator {
        isAcceptable(s: string): boolean;
    }
}
```

_LettersOnlyValidator.ts_
```ts
/// <reference path="Validation.ts" />
namespace Validation {
    const lettersRegexp = /^[A-Za-z]+$/;
    export class LettersOnlyValidator implements StringValidator {
        isAcceptable(s: string) {
            return lettersRegexp.test(s);
        }
    }
}
```

_Test.ts_
```ts
/// <reference path="Validation.ts" />
/// <reference path="LettersOnlyValidator.ts" />

let validators: { [s: string]: Validation.StringValidator; } = {};
validators["Letters only"] = new Validation.LettersOnlyValidator();
```

## Using Modules
* Just like namespaces, modules can contain both code and declarations. 
* Modules _declare_ their dependencies (e.g. top-level **import** or **export**).
* Modules provide for better code reuse, stronger isolation and better tooling support for bundling
* Starting with ECMAScript 2015, modules are native part of the language. For new projects, modules are the recommended code organization mechanism.

_Validation.ts_
```ts
export interface StringValidator {
    isAcceptable(s: string): boolean;
}
```

_LettersOnlyValidator.ts_
```ts

import { StringValidator } from "./Validation";
const lettersRegexp = /^[A-Za-z]+$/;

export class LettersOnlyValidator implements StringValidator {
    isAcceptable(s: string) {
        return lettersRegexp.test(s);
    }
}
```

_Test.ts_
```ts
import { StringValidator } from "./Validation";
import { LettersOnlyValidator } from "./LettersOnlyValidator";

let validators: { [s: string]: StringValidator; } = {};
validators["Letters only"] = new LettersOnlyValidator();
```

## Common Pitfalls

### `/// <reference>`-ing a module
A common mistake is to try to use the **`/// <reference ... />`** syntax to refer to a module file, rather than using an **import** statement.

The compiler will try to find a `.ts`, `.tsx`, and then a `.d.ts` with the appropriate path. If a specific file could not be found, then the compiler will look for an **_ambient module declaration_**. Recall that these need to be declared in a `.d.ts` file.

* myModules.d.ts
```ts
// In a .d.ts file or .ts file that is not a module:
declare module "SomeModule" {
    export function fn(): string;
}
```

* myOtherModule.ts
```ts
/// <reference path="myModules.d.ts" />
import * as m from "SomeModule";
```

The reference tag here allows us to locate the declaration file that contains the declaration for the ambient module. This is how the `node.d.ts` file that several of the TypeScript samples use is consumed.

_node.d.ts (simplified excerpt)_
```ts
declare module "url" {
    export interface Url {
        protocol?: string;
        hostname?: string;
        pathname?: string;
    }

    export function parse(urlStr: string, parseQueryString?, slashesDenoteHost?): Url;
}

declare module "path" {
    export function normalize(p: string): string;
    export function join(...paths: any[]): string;
    export var sep: string;
}
```

Now we can `/// <reference> node.d.ts` and then load the modules using `import url = require('url')` or `import * as URL from 'url'`.

```ts
/// <reference path="node.d.ts"/>
import * as URL from "url";
let myUrl = URL.parse("http://www.typescriptlang.org");
```

#### Shorthand ambient modules

If you don’t want to take the time to write out declarations before using a new module, you can use a shorthand declaration to get started quickly.

_declarations.d.ts_
```ts
declare module 'hot-new-module';
```

All imports from a shorthand module will have the **any** type.

```ts
import x, {y} from "hot-new-module";
```

### Needless Namespacing
When converting a program from namespaces to modules, it can be easy to end up with a file that looks like this:

* shapes.ts
```ts
export namespace Shapes {
    export class Triangle { /* ... */ }
    export class Square { /* ... */ }
}
```

The top-level modules here **Shapes** wraps up **Triangle** and **Square**:

* shapeConsumer.ts
```ts
import * as shapes from './shapes';
let t = new shapes.Shapes.Triangle(); // shapes.Shapes?
```

You should not try to namespace module contents:
* The general idea of namespacing is to provide logical grouping of constructs and to prevent name collisions.
* The module file itself is already a logical grouping, and its top-level name is defined by the code that imports it, it's unnecessary to use an additional layer for exported objects.

Here's a revised example:

* shapes.ts
```ts
export class Triangle { /* ... */ }
export class Square { /* ... */ }
```

* shapeConsumer.ts
```ts
import * as shapes from './shapes';
let t = new shapes.Triangle();
```

### Trade-offs of Modules
There is a one-to-one correspondence between JS files and modules, but it is not possible to concatenate multiple source files depending on the module system you target. For example:
* You cannnot use the `outFile` option while targeting `commonjs` or `umd`.
  - Concatenation with **CommonJS** does not make much sense, so is **UMD**, because of how commonjs works.
* With TypeScript 1.8 and later, it's possible to use `outFile` when targeting `amd` or `system`.

#### Concatenate AMD and System modules with --outFile

Specifying `--outFile` in conjunction with `--module amd` or `--module system` will concatenate all modules in the compilation into a single output file containing multiple module closures.

A module name will be computed for each module based on its relative location to rootDir.

_Example_

```js
// file src/a.ts
import * as B from "./lib/b";
export function createA() {
    return B.createB();
}
```

```js
// file src/lib/b.ts
export function createB() {
    return { };
}
```

Results in:
```js
define("lib/b", ["require", "exports"], function (require, exports) {
    "use strict";
    function createB() {
        return {};
    }
    exports.createB = createB;
});
define("a", ["require", "exports", "lib/b"], function (require, exports, B) {
    "use strict";
    function createA() {
        return B.createB();
    }
    exports.createA = createA;
});
```
