import SwiftUI
struct PagingScrollView<Content: View>: View {
    @StateObject var controller: PagingScrollController = PagingScrollController()
    @Binding var highlightedIndex: Int
    let items: [RowItem]
    let options: PagingScrollViewOptions
    @State var containerWidth: CGFloat = 0
    
    init<Data: RandomAccessCollection, ID>(_ options: PagingScrollViewOptions, highlightedIndex: Binding<Int>, @ViewBuilder content: () -> ForEach<Data, ID, Content>) {
        self._highlightedIndex = highlightedIndex
        self.options = options
        self.items = content().data
            .enumerated()
            .compactMap { index, element in
                RowItem(content().content(element), id: index)
            }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: options.itemSpacing) {
                    ForEach(items) { item in
                        item.view
                            .frame(width: options.itemSize.width, height: options.itemSize.height)
                            .onTapGesture {
                                selectIndex(item.id)
                            }
                        
                    }
                }
            }
            .content
            .offset(x: controller.isSwiping ? controller.offset : controller.offsetOnLastDragEnd)
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
            .clipped()
            .animation(.spring())
            .highPriorityGesture(
                DragGesture()
                    .onChanged({ value in
                        if !controller.isSwiping {
                            controller.highlightedIndexOnDragStart = highlightedIndex
                        }
                        controller.isSwiping = true
                        calculateDuringSwipe(value.translation.width)
                    }).onEnded({value in
                        withAnimation {
                            commitScroll(value.translation.width)
                            controller.isSwiping = false
                        }
                    })
            )
            .onAppear {
                containerWidth = proxy.size.width
            }
        }.onAppear {
            finalizeOffset()
        }
        .onChange(of: highlightedIndex) { newIndex in
            guard !controller.isSwiping else {
                return
            }
            finalizeOffset()
        }
    }
}

// MARK: - Scroll Calculations
extension PagingScrollView {
    private func calculateEndingOffset() -> CGFloat {
        let offset = calculateDefaultOffset()
        let finalOffset = offset + additionalOffset()
        return finalOffset
    }
    private func additionalOffset() -> CGFloat {
        guard options.contentMode == .center else {
            return 0
        }
        return (containerWidth - options.itemSize.width) / 2
    }
    
    private func calculateDefaultOffset() -> CGFloat {
        return -(options.itemSize.width + options.itemSpacing) * CGFloat(highlightedIndex)
    }
    
    private func getNewOffset(_ swipeDistance: CGFloat) -> CGFloat {
        switch options.contentMode {
        case .leading:
            return (controller.offsetOnLastDragEnd + CGFloat(highlightedIndex) * options.itemSpacing) + swipeDistance
        case .center:
            return controller.offsetOnLastDragEnd + swipeDistance - additionalOffset()
        }
    }
}

// MARK: - Scroll Invokements
extension PagingScrollView {
    private func calculateDuringSwipe(_ swipeDistance: CGFloat) {
        let newOffset = controller.offsetOnLastDragEnd + swipeDistance
        let newIndex = calculateClosestIndex(swipeDistance)
        if highlightedIndex != newIndex {
            setCurrentIndex(newIndex)
        }
        controller.offset = newOffset
    }
    private func commitScroll(_ swipeDistance: CGFloat) {
        let closestIndex = calculateClosestIndex(swipeDistance)
        if highlightedIndex != closestIndex {
            setCurrentIndex(closestIndex)
        }
        if controller.highlightedIndexOnDragStart == highlightedIndex {
            performSensitivityScrollIfNeeded(swipeDistance)
        }
        finalizeOffset()
    }
    /**
     Sets the final offset of the ScrollView when the user is no longer swiping
     Will also be invoked:
        - onAppear
        - When highlightedIndex is changed and the user is not swiping
     
     */
    private func finalizeOffset() {
        guard options.contentMode == .center else {
            controller.offsetOnLastDragEnd = calculateDefaultOffset()
            return
        }
        controller.offsetOnLastDragEnd = calculateEndingOffset()
    }
}
// MARK: - Calculate Highlighted Item
extension PagingScrollView {
    private func selectIndex(_ index: Int) {
        setCurrentIndex(index)
        finalizeOffset()
    }
    private func setCurrentIndex(_ index: Int) {
        highlightedIndex = index
    }
    
    /**
     Returns the index of the item that's closest to the ScrollViews offset
     */
    private func calculateClosestIndex(_ swipeDistance: CGFloat) -> Int {
        let newOffset = getNewOffset(swipeDistance)
        guard newOffset < 0 else {
            return 0
        }
        guard newOffset > -(options.itemSize.width * CGFloat(items.count - 1)) else {
            return items.count - 1
        }
        return Int(round(abs(newOffset) / options.itemSize.width))
    }
}

// MARK: - Sensitivity Based Scroll
extension PagingScrollView {
    private func performSensitivityScrollIfNeeded(_ swipeDistance: CGFloat) {
        if swipeDistance > requiredDistanceForSensitivity() {
            guard highlightedIndex - 1 >= 0 else {
                return
            }
            setCurrentIndex(highlightedIndex - 1)
        }
        else {
            guard swipeDistance < -requiredDistanceForSensitivity(), highlightedIndex + 1 <= items.count - 1 else {
                return
            }
            setCurrentIndex(highlightedIndex + 1)
            
        }
    }
    private func requiredDistanceForSensitivity() -> CGFloat {
        switch options.scrollSensitivity {
        case .fixed(.distance(let value)):
            return value
        case .dynamic(let ratio):
            return options.itemSize.width * ratio.rawValue
        }
    }
}

