### ease-out, in; ease-in, out
https://css-tricks.com/ease-out-in-ease-in-out/

### The Facebook Loading Animation in CSS | CSS-Tricks
https://css-tricks.com/the-facebook-loading-animation-in-css/

### center-the-content-inside-a-column-in-bootstrap-4
https://stackoverflow.com/questions/42528411/center-the-content-inside-a-column-in-bootstrap-4

There are multiple horizontal centering methods in Bootstrap 4...

text-center for center display:inline elements
offset-* or mx-auto can be used to center column (col-*)
or, justify-content-center on the row to center columns (col-*)
mx-auto for centering display:block elements inside d-flex
mx-auto (auto x-axis margins) will center display:block or display:flex elements that have a defined width, (%, vw, px, etc..). Flexbox is used by default on grid columns, so there are also various flexbox centering methods.

Demo of the Bootstrap 4 Centering Methods

In your case, use mx-auto to center the col-3 and text-center to center it's content..

```
<div class="row">
    <div class="col-3 mx-auto">
        <div class="text-center">
            center
        </div>
    </div>
</div>
```
http://www.codeply.com/go/GRUfnxl3Ol

or, using justify-content-center on flexbox elements (.row):

```
<div class="container">
    <div class="row justify-content-center">
        <div class="col-3 text-center">
            center
        </div>
    </div>
</div>
```
Also see:
Vertical Align Center in Bootstrap 4
