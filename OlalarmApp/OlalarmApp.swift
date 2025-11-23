import SharedData
import SQLiteData
import SwiftUI

@main
struct OlalarmApp: App {
    init() {
        prepareDependencies {
            $0.defaultDatabase = AppDatabase.shared
        }
    }

    var body: some Scene {
        WindowGroup {
            OlalarmUi()
        }
    }
}

struct OlalarmUi: View {
    @ObservationIgnored
    @State var router: Router = .init()
    @State var toast: AlarmToastViewModel = .init()
    @State var appState: AppState = .init()
    @AppStorage(AppSettings.KeyTheme) var theme: AppSettings.Theme = .system

    var body: some View {
        NavigationStack(path: Binding(get: { router.path }, set: { v in router.path = v })) {
            HomeScreen()
                .navigationDestination(for: Routes.self) { route in
                    switch route {
                    case let .modifyAlarm(id):
                        ModifyAlarmScreen(alarmId: id)

                    case .createAlarm:
                        ModifyAlarmScreen(alarmId: nil)

                    case .settings:
                        SettingsScreen()
                    }
                }
        }
        .alarmTriggerToast()
        .activeAlarmOverlay(activeAlarm: appState.activeAlarm)
        .environment(router)
        .environment(toast)
        .environment(appState)
        .preferredColorScheme(theme.asColorScheme)
    }
}
