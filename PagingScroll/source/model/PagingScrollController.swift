import SwiftUI
import Foundation
final class PagingScrollController: ObservableObject {
    /**
     Determines whether a swipe is in progress
     */
    @Published var isSwiping: Bool = false
    
    /**
     Current offset of the ScrollView
     */
    @Published var offset: CGFloat = 0
    
    @Published var offsetOnLastDragEnd: CGFloat = 0
    
    @Published var highlightedIndexOnDragStart: Int = 0
    
}
