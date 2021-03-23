import Foundation
import SwiftUI

struct ThemeView: View {
    @Binding var currentIndex: Int
    @State var selectedItem: ColorScheme = .red
    let contentMode: PagingScrollContentMode
    private let themes: [ColorScheme] = [.red, .blue, .yellow, .green, .pink, .purple]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            let currentScheme = selectedItem.resolve()
            currentScheme.background.edgesIgnoringSafeArea(.all)
            VStack() {
                PagingScrollView(data: themes, options: PagingScrollViewOptions(contentMode: contentMode, verticalPadding: 16, verticalGrowthBehavior: .fit), highlightedItem: $selectedItem, highlightedIndex: $currentIndex) { item in
                    build(item)
                    }
                
                Image(currentScheme.themeImageAssetName).resizable().cornerRadius(13).padding().id(selectedItem.hashValue)

            }
            
        }.animation(.spring())
    }
    
    @ViewBuilder func build(_ item: ColorScheme) -> some View {
        let isActive = selectedItem == item
        let scheme = item.resolve()
        RoundedRectangle(cornerRadius: isActive ? 13 : 0)
            .foregroundColor(scheme.background.opacity(isActive ? 1 : 0.6))
            .offset(x: 0, y: isActive ? -10 : 10)
            .shadow(color: Color.white.opacity(0.5), radius: isActive ? 6 : 0)
            .frame(width: 50, height: 50)
    }
}

