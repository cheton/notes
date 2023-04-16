https://ithelp.ithome.com.tw/articles/10227461

## flex 屬性
```
flex: flex-grow ｜ flex-shrink ｜ flex-basis
```

flex 屬性除了直接給定 flex-grow、flex-shrink、flex-basis 三個值之外，還有以下幾種寫法。

* flex: initial
* flex: auto
* flex: none
* flex: <正數>


### `flex: initial`
等同於 `flex： 0 1 auto`

flex item 會依照 width 或 height (視主軸 main axis 而定)屬性決定其尺寸，即使 container 中有剩餘空間，flex item 仍無法延伸，但當空間不足時，元素可收縮。

### `flex: auto`
等同於 `flex: 1 1 auto`

flex item 可延伸與收縮，會依照 width 或 height (視主軸 main axis 而定)屬性決定其尺寸。若所有 flex items 均設定 flex: auto 或 flex: none，則在 flex items 尺寸決定後，剩餘空間會被平分給 flex: auto 的 flex items。

### `flex: none`
等同於 `flex: 0 0 auto`

flex item 不可延伸與收縮，會依照 width 或 height (視主軸 main axis 而定)屬性決定其尺寸。

### `flex: <positive-number>`
等同於 `flex: <正數> 1 0`

flex item 可延伸與收縮，flex-basis 為 0，故 flex item 會依據所設定的比例佔用 container 中的剩餘空間。

例如

```
flex: 2;
```
等同於
```
flex: 2 1 0;
```

可利用此種屬性值的指定方式，輕易地決定 flex items 在 flex container 中所佔的尺寸比例 (width 或 height，視主軸 main axis 而定)。

例如，一個 flex container 裡面有三個 flex items，希望不管 container 如何變化，這三個 items 的尺寸皆一樣大，則可設定每個 items 的 flex 屬性有相同的正數(positive-number)。
