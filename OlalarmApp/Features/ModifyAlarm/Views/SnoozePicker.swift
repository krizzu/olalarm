import SharedData
import SwiftUI

private let SnoozeOptions = 1 ... 30
private let Default = 3

struct SnoozePicker: View {
    @State var enabled: Bool
    @Binding var snooze: Int?

    init(snooze: Binding<Int?>) {
        _snooze = snooze
        _enabled = State(initialValue: snooze.wrappedValue != nil)
    }

    var body: some View {
        Group {
            Toggle(enabled ? "Snooze on" : "Snooze off", isOn: $enabled.animation()).tint(.colorPrimary)

            if enabled {
                Picker("Snooze (minutes)", selection: $snooze) {
                    ForEach(SnoozeOptions, id: \.self) { minutes in
                        Text("\(minutes) \(minutes > 1 ? "mins" : "min")").tag(minutes).foregroundStyle(.colorPrimary)
                    }
                }
                .pickerStyle(.menu).tint(.colorPrimary)
            }
        }.onChange(of: enabled) { _, isEnabled in
            if !isEnabled {
                snooze = nil
            } else {
                snooze = Default
            }
        }
    }
}
