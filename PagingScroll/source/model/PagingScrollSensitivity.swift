import Foundation
import SwiftUI
enum PagingScrollSensitivity: Hashable {
    case fixed(_: StaticScrollSensitivity), dynamic(_: DynamicScrollSensitivity)
}
enum StaticScrollSensitivity: Hashable {
    case distance(_: CGFloat)
    
}
enum DynamicScrollSensitivity: CGFloat {
    case standard = 0.5, high = 0.25, extreme = 0.1
}
