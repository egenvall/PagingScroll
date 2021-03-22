import SwiftUI
struct RowItem: Identifiable {
    let id: Int
    let view: AnyView
    
    init<T: View>(_ view: T, id: Int) {
        self.view = AnyView(view)
        self.id = id
    }
}
