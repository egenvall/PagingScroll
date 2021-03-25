# PagingScroll

#### This is a work in progress & purely experimental and should be treated as such

The main reason behind this playground is to achieve a simple, reusable horizontal paging scroll that supports dynamic reloading of content with the flexibility reacting to the *highlighted* item. This project will end up supporting iOS 13.
If you want a dedicated pager there are better alternatives, especially if you're only supporting iOS 14 with `ScrollViewReader` as this is somewhat of a flexible in-between feature that always *pages* to an item when the scroll ends, but supports continuous scroll during the drag gesture.

The `PagingScrollView` can be customized through `PagingScrollViewOptions`

**PagingScrollViewOptions**  
 `itemSpacing: CGFloat`  
 `contentMode: PagingScrollContentMode`  
 `scrollSensitivity: PagingScrollSensitivity`  
 `verticalGrowthBehavior : PagingScrollVerticalGrowthBehavior`

**PagingScrollContentMode**  
Determines whether the focused item will anchor to leading or center of the frame  
```
enum PagingScrollContentMode {  
 case leading, center  
} 
```

**PagingScrollSensitivity**  
The scroll ratio needed to transition to the next item, can be either a dynamic ratio of the item size or a fixed scroll distance.  
``` 
enum PagingScrollSensitivity {
  case fixed(_: StaticScrollSensitivity), dynamic(_: DynamicScrollSensitivity)
}

enum StaticScrollSensitivity: Hashable {
    case distance(_: CGFloat)
    
}
enum DynamicScrollSensitivity: CGFloat {
    case standard = 0.5, high = 0.25, extreme = 0.1
}
```

**PagingScrollVerticalGrowthBehavior**  
Controls whether the PagingScrollView will fit around its content vertically or expand take up the available vertical space
```
enum PagingScrollVerticalGrowthBehavior {
    case fit, expand
}
```

## Usage
`struct PagingScrollView<Data: RandomAccessCollection, Content: View>: View where Data.Element : Hashable, Data.Index == Int, Data: Equatable`  
`init(_ data: Data, options: PagingScrollViewOptions = PagingScrollViewOptions(), onTapGesture: (() -> Void)? = nil, onHighlightedIndexChanged: ((Int) -> Void)? = nil, content: @escaping (Data.Element, Bool) -> Content)` 
```
private let themes: [ColorScheme] = [.red, .blue, .yellow, .green, .pink, .purple]

PagingScrollView(themes) { item, isActive in
    ZStack {
        item.resolve().background
        item.resolve().secondaryBackground.frame(width: 30, height: 30)
    }.frame(width: isActive ? 200 : 100, height: 100)
}
```

Each item has an `onTapGesture` which scrolls to that item.  
You can either tap to scroll, scroll continously or swipe to scroll to the next item depending on `PagingScrollSensitivity`
![Card](https://github.com/egenvall/PagingScroll/blob/main/PagingScroll/card-small.gif)
![Small](https://github.com/egenvall/PagingScroll/blob/main/PagingScroll/small.gif)
![Fullscreen](https://github.com/egenvall/PagingScroll/blob/main/PagingScroll/fullscreen.gif)


Check out the [Example](https://github.com/egenvall/PagingScroll/tree/main/PagingScroll/example) for more details
