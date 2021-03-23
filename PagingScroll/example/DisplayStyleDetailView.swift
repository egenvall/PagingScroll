import SwiftUI
import Foundation
struct DisplayStyleDetailView: View {
    @StateObject var viewModel: DisplayStyleDetailOptionViewModel = DisplayStyleDetailOptionViewModel()
    var displayStyle: DisplayStyle
    @State var centeredIndex = 0
    
    
    var body: some View {
        build()
    }
    @ViewBuilder func build() -> some View {
        switch displayStyle {
        case .smallLeading:
            smallView(.leading)
        case .smallCentered:
            smallView(.center)
        case .fullScreen:
            fullScreenView()
        case .cardLeading:
            cardView(.leading)
        case .cardCentered:
            cardView(.center)
        }
    }
    private func cardView(_ contentMode: PagingScrollContentMode) -> some View {
        CardView(currentIndex: $centeredIndex, contentMode: contentMode, sensitivity: .dynamic(.extreme))
            .navigationTitle("Card")
    }
    private func smallView(_ contentMode: PagingScrollContentMode) -> some View {
        ThemeView(currentIndex: $centeredIndex, contentMode: contentMode)
            .navigationTitle("Theme")
    }
    private func fullScreenView() -> some View {
        FullScreenView(currentIndex: $centeredIndex)
            .navigationTitle("Display")
    }
}
