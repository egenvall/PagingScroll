import SwiftUI
struct FullScreenView: View {
    private let themes: [ColorScheme] = [.red, .blue, .yellow, .green, .pink, .purple]
    var body: some View {
        GeometryReader { geo in
            PagingScrollView(themes) { item, isActive in
                ZStack {
                    item.resolve().background
                    item.resolve().secondaryBackground.frame(width: geo.size.width / 2, height: geo.size.height / 2)
                }.frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}
