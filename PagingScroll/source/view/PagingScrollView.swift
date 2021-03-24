import SwiftUI

struct PagingScrollView<Data: RandomAccessCollection, Content: View>: View where Data.Element : Hashable, Data.Index == Int {
    @StateObject private var controller: PagingScrollController = PagingScrollController()
    @State var containerWidth: CGFloat = 0
    @State private var itemSize: CGSize = .zero

    let data: Data
    let options: PagingScrollViewOptions
    @Binding var highlightedItem: Data.Element
    @State var highlightedIndex: Int = 0
    var onTapGesture: (() -> Void)? = nil
    var onHighlightedIndexChanged: ((Int) -> Void)? = nil
    let content: (Data.Element) -> Content
    
    var body: some View {
        GeometryReader { proxy in
            Color.clear.frame(height: 1)
              .preference(key: SizePreferenceKey.self, value: proxy.size)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: options.itemSpacing) {
                    ForEach(data, id: \.self) { item in
                        content(item)
                            .readSize { size in
                                print("Size: \(size)")
                                itemSize = size
                            }
                            .onTapGesture {
                                onTapGesture?()
                                selectItem(item)
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
        }
        .frame(height: options.verticalGrowthBehavior == .fit ? itemSize.height : nil)
        .onChange(of: highlightedIndex) { newIndex in
            guard !controller.isSwiping else {
                return
            }
            finalizeOffset()
        }.onPreferenceChange(SizePreferenceKey.self) { size in
            containerWidth = size.width
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
        return (containerWidth - itemSize.width) / 2
    }
    
    private func calculateDefaultOffset() -> CGFloat {
        return -(itemSize.width + options.itemSpacing) * CGFloat(highlightedIndex)
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
    
    // O(n)
    private func selectItem(_ item: Data.Element) {
        guard let index = data.firstIndex(of: item) else {
            return
        }
        withAnimation {
            highlightedItem = item
        }
        selectIndex(index)
    }
    private func selectIndex(_ index: Int) {
        setCurrentIndex(index)
        finalizeOffset()
    }
    private func setCurrentIndex(_ index: Int) {
        guard data.count - 1 >= index else {
            return
        }
        withAnimation {
            highlightedItem = data[index]
        }
        highlightedIndex = index
        onHighlightedIndexChanged?(highlightedIndex)
    }
    
    /**
     Returns the index of the item that's closest to the ScrollViews offset
     */
    private func calculateClosestIndex(_ swipeDistance: CGFloat) -> Int {
        let newOffset = getNewOffset(swipeDistance)
        guard newOffset < 0 else {
            return 0
        }
        guard newOffset > -(itemSize.width * CGFloat(data.count - 1)) else {
            return data.count - 1
        }
        return Int(round(abs(newOffset) / itemSize.width))
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
            guard swipeDistance < -requiredDistanceForSensitivity(), highlightedIndex + 1 <= data.count - 1 else {
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
            return itemSize.width * ratio.rawValue
        }
    }
}

