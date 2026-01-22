import SharedData
import SwiftUI

private let gridOptions = [
    1, 2,
]

struct SettingsScreen: View {
    @AppStorage(AppSettings.KeyTheme) var theme: AppSettings.Theme = .system
    @AppStorage(AppSettings.KeyGridSize) var gridSize: Int = 1
    @AppStorage(AppSettings.KeyBadge) var badgeEnabled: Bool = false
    @AppStorage(AppSettings.WarnDisabledAlarm) var warmDisabledAlarm: Bool = false
    @State var permissionMissingAlert: Bool = false

    var body: some View {
        ScreenPage {
            VStack {
                Form {
                    Section("") {
                        Picker("App theme", selection: $theme) {
                            ForEach(AppSettings.Theme.allCases, id: \.self) { selectedTheme in
                                Text(selectedTheme.description).tag(selectedTheme).foregroundStyle(.colorPrimary)
                            }
                        }
                        .pickerStyle(.menu).tint(.colorPrimary)

                        VStack(spacing: 8) {
                            Picker("Alarm grid size", selection: $gridSize) {
                                ForEach(1 ..< 3) { size in
                                    Text("\(size) per row").tag(size)
                                }
                            }
                            .pickerStyle(.menu).tint(.colorPrimary)
                            VStack {
                                Text("How alarms are arranged on the Home Screen").font(.caption2)
                                    .foregroundStyle(
                                        .colorTextPrimary.opacity(0.75)
                                    )
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }

                        VStack(spacing: 8) {
                            HStack {
                                Text("Badge indicator")
                                Spacer()
                                Toggle("", isOn: badgeToggleBinding).tint(.colorPrimary)
                            }
                            VStack {
                                Text("Adds a badge to app icon indicating number of active alarms")
                                    .font(.caption2)
                                    .foregroundStyle(
                                        .colorTextPrimary.opacity(0.75)
                                    )
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Confirm disabled alarm").lineLimit(1).layoutPriority(1)
                                Spacer()
                                Toggle("", isOn: $warmDisabledAlarm).tint(.colorPrimary)
                            }
                            VStack {
                                Text("Prompts for confirmation when saving an alarm that is disabled").font(.caption2)
                                    .foregroundStyle(
                                        .colorTextPrimary.opacity(0.75)
                                    )
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                }.scrollContentBackground(.hidden)

                Spacer()
                Text("version: \(AppSettings.appVersion)")
                    .font(.caption2)
                    .foregroundStyle(.colorTextPrimary)
                    .opacity(0.75)
            }
        }.navigationTitle(Text("Settings"))
            .alert("Missing permissions", isPresented: $permissionMissingAlert) {
                Button(action: { permissionMissingAlert = false
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }, label: { Text("Open settings") })

                Button(action: { permissionMissingAlert = false }, label: { Text("Ok") })

            } message: {
                Text("Permissions for notifications are required. Go to App settings in Options to grant it.")
            }
    }

    // allow to toggle the feature on only if permissions are granted
    var badgeToggleBinding: Binding<Bool> {
        Binding<Bool>(
            get: {
                badgeEnabled && BadgeService.shared.hasPermissions
            },
            set: { newValue in
                Task {
                    if newValue {
                        // Request permission if needed
                        let granted = await BadgeService.shared.requestPermissions()
                        if granted {
                            badgeEnabled = true
                            await BadgeService.shared.updateBadgeCount()
                        } else {
                            permissionMissingAlert = true
                            badgeEnabled = false
                        }
                    } else {
                        badgeEnabled = false
                        await BadgeService.shared.updateBadgeCount()
                    }
                }
            }
        )
    }
}

#Preview {
    SettingsScreen(theme: .light, gridSize: 1)
}
