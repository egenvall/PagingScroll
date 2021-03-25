import SwiftUI
struct CardView: View {
    let contentMode: PagingScrollContentMode
    @State var sensitivity: PagingScrollSensitivity = .dynamic(.standard)    
    @State var themes: [ColorScheme] = [.red, .blue, .yellow, .green, .pink, .purple]
    var body: some View {
        VStack {
            Text("Swipe Sensitivity").font(.title3)
            Picker(selection: $sensitivity, label: Text("Paging Sensitivity")) {
                Text("Default").tag(PagingScrollSensitivity.dynamic(.standard))
                Text("High").tag(PagingScrollSensitivity.dynamic(.high))
                Text("Extreme").tag(PagingScrollSensitivity.dynamic(.extreme))
                Text("Static 50").tag(PagingScrollSensitivity.fixed(.distance(50)))
                
            }
            .pickerStyle(SegmentedPickerStyle()).padding([.horizontal])
            
            GeometryReader { geo in
                PagingScrollView(themes, options: PagingScrollViewOptions(sensitivity, contentMode: contentMode, verticalGrowthBehavior: .expand), onHighlightedIndexChanged: onHighlightedIndexChange) { item, isActive in
                    build(item, proxy: geo, isActive: isActive)
                }
            }
            
        }
    }
    @ViewBuilder func build(_ item: ColorScheme, proxy: GeometryProxy, isActive: Bool) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(item.resolve().themeImageAssetName)
                .resizable()
                .cornerRadius(isActive ? 14 : 0)
                .clipped()
            Button("Delete") {
                print("Tappy Delete")
                deleteItem(item)
            }.buttonStyle(CapsuleButton())
            .padding()
                
        }.frame(width: proxy.size.width - 64, height: proxy.size.height - 64)
        .scaleEffect(CGSize(width: 1, height: isActive ? 1 : 0.85))
    }
    private func deleteItem(_ item: ColorScheme) {
        guard !themes.isEmpty else {
            return
        }
        guard let index = themes.firstIndex(of: item) else {
            print("P2 Fail")
            return
        }
        themes.remove(at: index)
    }
    func onHighlightedIndexChange(_ newIndex: Int) {
        
    }
}
struct CapsuleButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(Font.subheadline.bold())
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.6) : Color.white)
            .padding([.horizontal])
            .padding([.vertical], 8)
            .background(configuration.isPressed ? Color.red.opacity(0.6) : Color.red)
            .clipShape(Capsule())
    }
}
