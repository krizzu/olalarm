import Combine
import SwiftUI

@Observable
@MainActor
class Router {
    var path = NavigationPath()

    func resetToHome() {
        path = NavigationPath()
    }

    func navigateToModifyAlarm(id: UUID) {
        path.append(Routes.modifyAlarm(id: id))
    }

    func navigateToCreateAlarm() {
        path.append(Routes.createAlarm)
    }

    func navigateToSettings() {
        path.append(Routes.settings)
    }
}

enum Routes: Hashable {
    case modifyAlarm(id: UUID)

    case createAlarm

    case settings
}
