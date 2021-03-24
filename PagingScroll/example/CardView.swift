import SwiftUI
struct CardView: View {
    //@Binding var currentIndex: Int
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
                Color.black
//                PagingScrollView(PagingScrollViewOptions(sensitivity, contentMode: contentMode, itemSpacing: 8, verticalPadding: 8, verticalGrowthBehavior: .expand), highlightedIndex: $currentIndex) {
//                    ForEach(themes, id: \.self) { item in
//                        let scheme = item.resolve()
//                        let isActive = themes[currentIndex] == item
//                        ZStack {
//                            scheme.background.cornerRadius(isActive ? 13 : 0)
//                            Text("The quick brown fox jumps over the lazy dog").font(.title2).foregroundColor(scheme.primaryText).padding()
//                        }.frame(width: geo.size.width - 64, height: geo.size.height - 64).scaleEffect(CGSize(width: 1, height: isActive ? 1 : 0.85))
//                    }
//                }
            }
            HStack {
//                Button("Remove Card") {
//                    guard !themes.isEmpty else {
//                        return
//                    }
//                    let indexToRemove = currentIndex
//                    if currentIndex != 0 {
//                        currentIndex -= 1
//                    }
//                    themes.remove(at: indexToRemove)
//                    
//                }
//                Spacer()
//                Button("Replace Content") {
//                    themes = [.red, .purple, .pink]
//                    currentIndex = 0
//                }
            }.padding([.horizontal])
            
            
        }
        
    }
}
