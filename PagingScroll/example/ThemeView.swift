import Foundation
import SwiftUI

struct ThemeView: View {
    @State var centeredIndex = 0
    @State var selectedItem: ColorScheme = .red
    let contentMode: PagingScrollContentMode
    private let themes: [ColorScheme] = [.red, .blue, .yellow, .green, .pink, .purple]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            let currentScheme = selectedItem.resolve()
            currentScheme.background.edgesIgnoringSafeArea(.all)
            VStack() {
                PagingScrollView(data: themes, options: PagingScrollViewOptions(contentMode: contentMode), highlightedItem: $selectedItem, onHighlightedIndexChanged: onIndexChange) { item in
                    build(item)
                }
                Image(currentScheme.themeImageAssetName).resizable().cornerRadius(13).padding().id(selectedItem.hashValue)
            }
            
        }.animation(.spring())
    }
    
    func onIndexChange(_ newIndex: Int) {
        print("New Index: \(newIndex)")
    }
    @ViewBuilder func build(_ item: ColorScheme) -> some View {
        let isActive = selectedItem == item
        let scheme = item.resolve()
        RoundedRectangle(cornerRadius: isActive ? 13 : 0)
            .foregroundColor(scheme.background.opacity(isActive ? 1 : 0.6))
            .offset(x: 0, y: isActive ? -10 : 10)
            .shadow(color: Color.white.opacity(0.5), radius: isActive ? 6 : 0)
            .frame(width: 50, height: 50)
            .padding([.vertical], 20)
    }
}

