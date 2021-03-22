import SwiftUI
struct PagingScrollViewOptions: Equatable {
    let itemSpacing: CGFloat
    let itemSize: CGSize
    let contentMode: PagingScrollContentMode
    let scrollSensitivity: PagingScrollSensitivity
    
    init(_ sensitivity: PagingScrollSensitivity = .dynamic(.standard), contentMode: PagingScrollContentMode = .center, itemSpacing: CGFloat = 8, itemSize: CGSize) {
        scrollSensitivity = sensitivity
        self.contentMode = contentMode
        self.itemSpacing = itemSpacing
        self.itemSize = itemSize
    }
}
