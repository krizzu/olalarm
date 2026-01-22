import Dependencies
import SharedData
import SwiftUI

struct ModifyAlarmScreen: View {
    let alarmId: UUID?

    @Environment(Router.self) private var router
    @Environment(AlarmToastViewModel.self) private var toast
    @State private var vm: ModifyAlarmViewModel = .init()
    @AppStorage(AppSettings.WarnDisabledAlarm) var warmDisabledAlarm: Bool = false

    @State private var actionError: OlalarmError? = nil

    @State private var name: String = "My Alarm"
    @State private var time: Date = .now.addingTimeInterval(60 * 60)
    @State private var isEnabled: Bool = true

    @State private var snoozeMinutes: Int? = 3
    @State private var sound: OlalarmSound? = nil
    @State private var exitAlert = false

    init(alarmId: UUID? = nil) {
        self.alarmId = alarmId
    }

    func saveAndExit(_ id: UUID?, _ name: String, _ time: Date, _ enabled: Bool, _ snooze: Int?, _ sound: OlalarmSound?) async {
        let result = if let alarmId = id {
            await vm.save(id: alarmId, name: name, timeTrigger: time, enabled: enabled, snooze: snooze, soundId: sound?.id)
        } else {
            await vm.create(name: name, timeTrigger: time, enabled: enabled, snooze: snooze, soundId: sound?.id)
        }

        switch result {
        case let .failure(error):
            actionError = error
        case let .success(saved):
            if saved.enabled {
                toast.trigger(date: saved.trigger.relativeDate())
            }
            router.resetToHome()
        }
    }

    // asks user if alarm should be enabled before exit
    func onSaveAndExit() {
        if !isEnabled && warmDisabledAlarm {
            exitAlert = true
            return
        }

        onSetEnableAndExit(alarmEnabled: isEnabled)
    }

    func onSetEnableAndExit(alarmEnabled: Bool) {
        isEnabled = alarmEnabled
        Task {
            await saveAndExit(alarmId, name, time, alarmEnabled, snoozeMinutes, sound)
        }
    }

    var body: some View {
        ScreenPage {
            VStack {
                Form {
                    Section("Alarm details") {
                        TextField("Name", text: $name)

                        DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)

                        Toggle(isEnabled ? "On" : "Off", isOn: $isEnabled).tint(.colorPrimary)

                    }.listRowBackground(Color.colorSurface)

                    Section("Snooze") {
                        SnoozePicker(snooze: $snoozeMinutes)
                    }.listRowBackground(Color.colorSurface)

                    Section("Sound") {
                        SoundPicker(sound: $sound)
                    }.listRowBackground(Color.colorSurface)

                }.scrollContentBackground(.hidden)

                ButtonDefault(text: "save", colorText: .white, colorBackground: .colorAccent, maxWidth: .infinity, action: onSaveAndExit).padding(.horizontal)
            }
        }
        .alert("Enable alarm?", isPresented: $exitAlert) {
            Button("Enable", role: .confirm) {
                onSetEnableAndExit(alarmEnabled: true)
                exitAlert = false
            }
            Button("No", role: .close) {
                onSetEnableAndExit(alarmEnabled: isEnabled)
                exitAlert = false
            }
        } message: {
            Text("You are about to save disabled alarm. Do you want to enable it now?")
        }
        .navigationTitle(Text(alarmId == nil ? "Create alarm" : "Modify alarm"))
        .task {
            guard let id = alarmId else {
                return
            }

            let result = await vm.find(id: id)
            switch result {
            case let .failure(error):
                actionError = error
            case let .success(alarm):
                name = alarm.name
                time = alarm.trigger.toDate()
                isEnabled = alarm.enabled
                sound = alarm.sound
                snoozeMinutes = alarm.snooze
            }
        }.errorAlert(error: $actionError)
    }
}

#Preview {
    ModifyAlarmScreen().environment(Router()).environment(AlarmToastViewModel())
}

private extension Olalarm.Trigger {
    func toDate() -> Date {
        let d = Calendar.current
        let date = d.date(bySettingHour: hour, minute: minute, second: 0, of: Date.now)
        return date ?? Date.now.addingTimeInterval(60 * 3) // next 3 mins
    }
}
