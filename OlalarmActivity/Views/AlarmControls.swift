import ActivityKit
import AlarmKit
import AppIntents
import SharedData
import SwiftUI
import WidgetKit

struct AlarmControls: View {
    var presentation: AlarmPresentation
    var state: AlarmPresentationState

    var body: some View {
        HStack(spacing: 12) {
            switch state.mode {
            case .alert:
                ButtonView(
                    intent: OlalarmAppIntents.Snooze(alarmID: state.alarmID.uuidString),
                    systemImage: "zzz",
                    colorText: .white,
                    colorBackground: .colorAccent,
                )
            default:
                EmptyView()
            }

            ButtonView(
                intent: OlalarmAppIntents.Stop(alarmID: state.alarmID.uuidString),
                systemImage: "stop.circle",
                colorText: .colorTextPrimary,
                colorBackground: .colorBackground,
            )
        }
    }
}

struct ButtonView<I>: View where I: LiveActivityIntent {
    var intent: I
    var systemImage: String
    var colorText: Color
    var colorBackground: Color

    var body: some View {
        Button(intent: intent) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .padding(12)
                .foregroundStyle(colorText)
        }
        .buttonStyle(.plain)
        .tint(nil)
        .frame(maxWidth: 45, maxHeight: 45)
        .background(colorBackground)
        .cornerRadius(.infinity)
    }
}
