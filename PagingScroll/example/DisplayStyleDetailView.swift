import SwiftUI
import Foundation
struct DisplayStyleDetailView: View {
    @StateObject var viewModel: DisplayStyleDetailOptionViewModel = DisplayStyleDetailOptionViewModel()
    var displayStyle: DisplayStyle
    
    
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
        CardView(contentMode: contentMode, sensitivity: .dynamic(.extreme))
            .navigationTitle("Card")
    }
    private func smallView(_ contentMode: PagingScrollContentMode) -> some View {
        ThemeView(contentMode: contentMode)
            .navigationTitle("Theme")
    }
    private func fullScreenView() -> some View {
        FullScreenView()
            .navigationTitle("Display")
    }
}
