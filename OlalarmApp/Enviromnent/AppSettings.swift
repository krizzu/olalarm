import SwiftUI

struct AppSettings {
    static let KeyTheme: String = "app_theme"
    static let KeyGridSize: String = "app_grid_size"
    static let KeyBadge: String = "app_badge"
    static let WarnDisabledAlarm: String = "app_ask_before_save"

    enum Theme: String, CaseIterable, Hashable {
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


extension AppSettings {
    static var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    }
}

extension AppSettings.Theme {
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
