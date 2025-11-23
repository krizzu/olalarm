import AlertToast
import SharedData
import SwiftUI

@Observable
class AlarmToastViewModel {
    var date: Date?

    func trigger(date: Date) {
        self.date = date
    }

    func dismiss() {
        date = nil
    }
}

private struct AlarmTriggerToast<Presenting>: View where Presenting: View {
    let presenting: () -> Presenting
    @Environment(AlarmToastViewModel.self) private var toastVM
    @Environment(\.colorScheme) private var colorScheme

    func calculateTime() -> String? {
        guard let date = toastVM.date else { return "-" }
        let interval = date.timeIntervalSinceNow
        if interval <= 0 {
            return "Time left: less than a minute"
        }

        // convert to minutes and round
        let totalMinutes = Int((interval / 60).rounded())
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        let htext = hours == 1 ? "hour" : "hours"
        let mtext = minutes == 1 ? "minute" : "minutes"

        if hours < 1 {
            if minutes < 1 {
                return "Time left: less than a minute"
            } else {
                return "Time left: \(minutes) \(mtext)"
            }

        } else {
            return "Time left: \(hours) \(htext) \(minutes) \(mtext)"
        }
    }

    var body: some View {
        presenting()
            .toast(isPresenting: Binding(
                get: { toastVM.date != nil },
                set: { if $0 == false {
                    toastVM.dismiss()
                }}
            ), duration: 5) {
                AlertToast(
                    displayMode: .banner(.pop),
                    type: .regular,
                    title: calculateTime(),
                    style: .style(
                        backgroundColor: colorScheme == .dark ? Color.LightColor : Color.DarkColor,
                        titleColor: colorScheme == .dark ? Color.DarkColor : Color.LightColor
                    )
                )

            } onTap: {
                toastVM.dismiss()
            }
    }
}

private extension Color {
    init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacing("#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }

    static var DarkColor: Color {
        Color(hex: "#1B142D")
    }

    static var LightColor: Color {
        Color(hex: "#FFFFFF")
    }

}

extension View {
    func alarmTriggerToast() -> some View {
        AlarmTriggerToast(presenting: { self })
    }
}
