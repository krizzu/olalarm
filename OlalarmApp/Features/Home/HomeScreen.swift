import AlarmKit
import Dependencies
import SharedData
import SwiftData
import SwiftUI

struct HomeScreen: View {
    @Environment(Router.self) private var router
    @Environment(AlarmToastViewModel.self) private var toast
    @State private var vm: HomeViewModel = .init()
    @State private var actionError: OlalarmError? = nil
    @AppStorage(AppSettings.KeyGridSize) var gridSize: Int = 1

    func toggleAlarm(_ alarm: Olalarm) {
        Task {
            let result = await vm.toggle(alarm)

            switch result {
            case let .failure(error):
                actionError = error

            case let .success(updated):
                if updated.enabled {
                    toast.trigger(date: alarm.trigger.relativeDate())
                } else {
                    toast.dismiss()
                }
            }
        }
    }

    func removeAlarm(_ alarm: Olalarm) {
        Task {
            let result = await vm.delete(alarm: alarm)

            switch result {
            case let .failure(error):
                actionError = error

            case .success:
                break
            }
        }
    }

    var body: some View {
        ScreenPage {
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: gridSize)) {
                    ForEach(vm.alarms) { alarm in
                        AlarmView(alarm: alarm, small: gridSize > 1, onToggle: { _ in
                            toggleAlarm(alarm)
                        })
                        .onTapGesture {
                            router.navigateToModifyAlarm(id: alarm.id)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                removeAlarm(alarm)
                            } label: {
                                Text("Delete")
                            }
                        }
                    }
                }.padding(.horizontal, 12)
            }
        }.navigationTitle(Text("Your alarms"))
            .toolbar {
                toolbarMenu
            }
            .errorAlert(error: $actionError)
    }

    var toolbarMenu: some View {
        Menu {
            Button(action: {
                router.navigateToCreateAlarm()
            }) {
                Label("Add alarm", systemImage: "plus.circle")
            }.foregroundStyle(.colorTextPrimary)

            Button(action: {
                router.navigateToSettings()
            }) {
                Label("Settings", systemImage: "gear")
            }.foregroundStyle(.colorTextPrimary)
        } label: {
            Image(systemName: "line.3.horizontal").foregroundStyle(.colorAccent)
        }
    }
}

#Preview {
    ScreenPage {
        HomeScreen()
    }.environment(Router())
        .environment(AlarmToastViewModel())
}
