import SwiftUI
final class DisplayStyleDetailOptionViewModel: ObservableObject {
    @Published var spacing: CGFloat = 0
    @Published var sensitivity: PagingScrollSensitivity = .dynamic(.standard)
    @Published var contentMode: PagingScrollContentMode = .leading
}

