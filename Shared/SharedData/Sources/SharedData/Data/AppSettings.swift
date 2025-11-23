import SwiftUI

public struct AppSettings {
    public static let KeyTheme: String = "app_theme"
    public static let KeyGridSize: String = "app_grid_size"
    public static let KeyBadge: String = "app_badge"

    public enum Theme: String, CaseIterable, Hashable {
        case light, dark, system

        var description: String {
            switch self {
            case .light: return "Light"
            case .dark: return "Dark"
            case .system: return "System"
            }
        }
    }
}


public extension AppSettings {
    static var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    }
}

public extension AppSettings.Theme {
    var asColorScheme: ColorScheme? {
        switch self {
        case .dark:
            return ColorScheme.dark
        case .light:
            return ColorScheme.light
        default:
            return nil
        }
    }
}
