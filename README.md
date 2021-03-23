# PagingScroll

#### This is a work in progress & purely experimental and should be treated as such

The main reason behind this playground is to achieve a simple, reusable horizontal paging scroll that supports dynamic reloading of content with the flexibility of targeting the *highlighted* item.  
If you want a dedicated pager there are better alternatives as this is somewhat of a flexible in-between feature that always *pages* to an item when the scroll ends, but supports continuous scroll during the drag gesture.

The `PagingScrollView` can be customized through `PagingScrollViewOptions`

**PagingScrollViewOptions**  
 `itemSpacing: CGFloat`  
 `itemSize: CGFloat`  
 `contentMode: PagingScrollContentMode`  
 `scrollSensitivity: PagingScrollSensitivity`

**PagingScrollContentMode**  
Determines whether the focused item will anchor to leeading or center of the frame  
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

## Usage
`init<Data: RandomAccessCollection, ID>(_ options: PagingScrollViewOptions, highlightedIndex: Binding<Int>, @ViewBuilder content: () -> ForEach<Data, ID, Content>)` 
```
PagingScrollView(PagingScrollViewOptions(itemSize: CGSize(width: 50, height: 50)), highlightedIndex: $currentIndex) {
  ForEach(themes, id: \.self) { item in
    let isActive = themes[currentIndex] == item
    let scheme = item.resolve()
    RoundedRectangle(cornerRadius: isActive ? 13 : 0)
    .foregroundColor(scheme.background)
    .shadow(color: Color.white.opacity(0.5), radius: isActive ? 6 : 0)
                            
  }
}.frame(height: 70)
```

You can use a `.frame(...)` to control the size of the `PagingScrollView` as it clips the contents.  
The highlighted index is currently passed as a `Binding<Int>` which allows you to customize the *highlighted* item, this is subject to change

Each item has an `onTapGesture` which scrolls to that item.  
You can either tap to scroll, scroll continously or swipe to scroll to the next item depending on `PagingScrollSensitivity`






https://user-images.githubusercontent.com/3669105/112120847-ea8ba700-8bbe-11eb-989b-522bdd7bad31.MP4



https://user-images.githubusercontent.com/3669105/112121213-45250300-8bbf-11eb-851d-b8061eba68f5.MP4

Check out the [Example](https://github.com/egenvall/PagingScroll/tree/main/PagingScroll/example) for more details
