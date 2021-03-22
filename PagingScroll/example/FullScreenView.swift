import SwiftUI
struct FullScreenView: View {
    @Binding var currentIndex: Int
    private let themes: [ColorScheme] = [.red, .blue, .yellow, .green, .pink, .purple]

    var body: some View {
        GeometryReader { geo in
            PagingScrollView(PagingScrollViewOptions(itemSpacing: 0, itemSize: CGSize(width: geo.size.width, height: geo.size.height)), highlightedIndex: $currentIndex) {
                ForEach(themes, id: \.self) { item in
                    let scheme = item.resolve()
                    ZStack {
                        scheme.background
                        scheme.secondaryBackground.frame(width: geo.size.width / 2, height: geo.size.height / 2)
                    }
                }
            }
        }
    }
}
