import SwiftUI
enum ColorScheme {
    case red, blue, yellow, green, pink, purple
    func resolve() -> Theme {
        return Theme(
            background: background(),
            secondaryBackground: secondaryBackground(),
            primaryText: text(),
            secondaryText: secondaryText()
        )
    }
    private func background() -> Color {
        switch self {
        case .red:
            return Color("backgroundRed")
        case .blue:
            return Color("backgroundBlue")
        case .green:
            return Color("backgroundGreen")
        case .yellow:
            return Color("backgroundYellow")
        case .pink:
            return  Color("backgroundPink")
        case .purple:
            return Color("backgroundPurple")
        }
    }
    private func secondaryBackground() -> Color {
        switch self {
        case .red:
            return Color("secondaryBackgroundRed")
        case .blue:
            return Color("secondaryBackgroundBlue")
        case .green:
            return Color("secondaryBackgroundGreen")
        case .yellow:
            return Color("secondaryBackgroundYellow")
        case .pink:
            return  Color("secondaryBackgroundPink")
        case .purple:
            return Color("secondaryBackgroundPurple")
        }
    }
    private func text() -> Color {
        switch self {
        case .yellow:
            return  Color("primaryTextDark")
        default:
            return Color("primaryTextLight")
        }
    }
    private func secondaryText() -> Color {
        switch self {
        case .yellow:
            return  Color("secondaryTextDark")
        default:
            return Color("secondaryTextLight")
        }
    }
}
