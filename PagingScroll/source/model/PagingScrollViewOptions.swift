import SwiftUI
enum PagingScrollVerticalGrowthBehavior {
    case fit, expand
}
struct PagingScrollViewOptions: Equatable {
    let itemSpacing: CGFloat
    let verticalPadding: CGFloat
    let contentMode: PagingScrollContentMode
    let scrollSensitivity: PagingScrollSensitivity
    let verticalGrowthBehavior: PagingScrollVerticalGrowthBehavior
    
    init(_ sensitivity: PagingScrollSensitivity = .dynamic(.standard), contentMode: PagingScrollContentMode = .center, itemSpacing: CGFloat = 8, verticalPadding: CGFloat = 0, verticalGrowthBehavior: PagingScrollVerticalGrowthBehavior = .fit) {
        scrollSensitivity = sensitivity
        self.contentMode = contentMode
        self.itemSpacing = itemSpacing
        self.verticalPadding = verticalPadding
        self.verticalGrowthBehavior = verticalGrowthBehavior
    }
}
