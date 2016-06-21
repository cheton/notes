## Bootstrap 3 Responsive Columns of Same Height

Source: http://www.minimit.com/articles/solutions-tutorials/bootstrap-3-responsive-columns-of-same-height

### The Markup
```html
<div class="row">
  <div class="row-sm-height">
    <div class="col-xs-12 col-sm-6 col-sm-height">
      <div class="col-content">
        <div class="container-fluid"><br><br><br><br><br><br><br></div>
      </div>
    </div>
    <div class="col-xs-6 col-sm-3 col-sm-height col-sm-top">
      <div class="col-content">
        <div class="container-fluid"></div>
      </div>
    </div>
    <div class="col-xs-6 col-sm-2 col-sm-height col-sm-middle">
      <div class="col-content">
        <div class="container-fluid"></div>
      </div>
    </div>
    <div class="col-xs-6 col-sm-1 col-sm-height col-sm-bottom">
      <div class="col-content col-content-full-height">
        <div class="container-fluid">
          To have columns full height use the class .col-content-full-height, it gives 100% height to the content container.
        </div>
      </div>
    </div>
   </div>
</div>
```

### The CSS
```css
.row-height {
  display: table;
  table-layout: fixed;
  height: 100%;
  width: 100%;
}
.col-height {
  display: table-cell;
  float: none;
  height: 100%;
}
.col-top {
  vertical-align: top;
}
.col-middle {
  vertical-align: middle;
}
.col-bottom {
  vertical-align: bottom;
}
.col-content {
  margin-top: 10px;
  margin-bottom: 10px;
}
.col-content-full-height {
  height: 100%;
  margin-top: 0;
  margin-bottom: 0;
}

@media (min-width: 480px) {
  .row-xs-height {
    display: table;
    table-layout: fixed;
    height: 100%;
    width: 100%;
  }
  .col-xs-height {
    display: table-cell;
    float: none;
    height: 100%;
  }
  .col-xs-top {
    vertical-align: top;
  }
  .col-xs-middle {
    vertical-align: middle;
  }
  .col-xs-bottom {
    vertical-align: bottom;
  }
}

@media (min-width: 768px) {
  .row-sm-height {
    display: table;
    table-layout: fixed;
    height: 100%;
    width: 100%;
  }
  .col-sm-height {
    display: table-cell;
    float: none;
    height: 100%;
  }
  .col-sm-top {
    vertical-align: top;
  }
  .col-sm-middle {
    vertical-align: middle;
  }
  .col-sm-bottom {
    vertical-align: bottom;
  }
}

@media (min-width: 992px) {
  .row-md-height {
    display: table;
    table-layout: fixed;
    height: 100%;
    width: 100%;
  }
  .col-md-height {
    display: table-cell;
    float: none;
    height: 100%;
  }
  .col-md-top {
    vertical-align: top;
  }
  .col-md-middle {
    vertical-align: middle;
  }
  .col-md-bottom {
    vertical-align: bottom;
  }
}

@media (min-width: 1200px) {
  .row-lg-height {
    display: table;
    table-layout: fixed;
    height: 100%;
    width: 100%;
  }
  .col-lg-height {
    display: table-cell;
    float: none;
    height: 100%;
  }
  .col-lg-top {
    vertical-align: top;
  }
  .col-lg-middle {
    vertical-align: middle;
  }
  .col-lg-bottom {
    vertical-align: bottom;
  }
}
```
