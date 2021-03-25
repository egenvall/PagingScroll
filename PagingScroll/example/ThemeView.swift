import Foundation
import SwiftUI

struct ThemeView: View {
    @State var activeIndex: Int = 0
    let contentMode: PagingScrollContentMode
    private let themes: [ColorScheme] = [.red, .blue, .yellow, .green, .pink, .purple]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            let currentScheme = themes[activeIndex]
            VStack() {
                PagingScrollView(themes, options: PagingScrollViewOptions(contentMode: contentMode), onHighlightedIndexChanged: onIndexChange) { item, isActive in
                    build(item, isActive: isActive)
                }
                Image(currentScheme.resolve().themeImageAssetName).resizable().cornerRadius(13).padding().id(currentScheme.hashValue)
            }
            
        }.animation(.spring())
    }
    
    func onIndexChange(_ newIndex: Int) {
        activeIndex = newIndex
    }
    @ViewBuilder func build(_ item: ColorScheme, isActive: Bool) -> some View {
        let scheme = item.resolve()
        RoundedRectangle(cornerRadius: isActive ? 14 : 0)
            .foregroundColor(scheme.background.opacity(isActive ? 1 : 0.6))
            .offset(x: 0, y: isActive ? -10 : 0)
            .shadow(color: Color.white.opacity(0.5), radius: isActive ? 6 : 0)
            .frame(width: 50, height: 50)
            .padding([.vertical], 20)
    }
}

