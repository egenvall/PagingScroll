import Foundation
import SwiftUI

struct ThemeView: View {
    @Binding var currentIndex: Int
    let contentMode: PagingScrollContentMode
    private let themes: [ColorScheme] = [.red, .blue, .yellow, .green, .pink, .purple]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            let currentScheme = themes[currentIndex].resolve()
            currentScheme.background.edgesIgnoringSafeArea(.all)
            VStack() {
                PagingScrollView(PagingScrollViewOptions(contentMode: contentMode, itemSize: CGSize(width: 50, height: 50)), highlightedIndex: $currentIndex) {
                    ForEach(themes, id: \.self) { item in
                        let isActive = themes[currentIndex] == item
                        let scheme = item.resolve()
                        RoundedRectangle(cornerRadius: isActive ? 13 : 0)
                            .foregroundColor(scheme.background).shadow(color: Color.white.opacity(0.5), radius: isActive ? 6 : 0)
                            
                    }
                }.frame(height: 70)
                
                VStack(spacing: 16) {
                    Text("The quick brown fox jumps over the lazy dog").font(.title).foregroundColor(currentScheme.primaryText)
                    ZStack {
                        currentScheme.secondaryBackground.cornerRadius(13)
                        HStack {
                            Text("Jump jump jump jump").font(.body).foregroundColor(currentScheme.secondaryText)
                        }
                    }.padding()
                }
            }
        }.animation(.spring())
    }
}
