import SwiftUI

struct PagingScrollViewOptions: Equatable {
    let itemSpacing: CGFloat
    let contentMode: PagingScrollContentMode
    let scrollSensitivity: PagingScrollSensitivity
    let verticalGrowthBehavior: PagingScrollVerticalGrowthBehavior
    
    init(_ sensitivity: PagingScrollSensitivity = .dynamic(.standard), contentMode: PagingScrollContentMode = .center, itemSpacing: CGFloat = 8, verticalGrowthBehavior: PagingScrollVerticalGrowthBehavior = .fit) {
        scrollSensitivity = sensitivity
        self.contentMode = contentMode
        self.itemSpacing = itemSpacing
        self.verticalGrowthBehavior = verticalGrowthBehavior
    }
}
