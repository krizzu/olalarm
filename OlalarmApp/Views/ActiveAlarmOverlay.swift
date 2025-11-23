import AlarmKit
import SharedData
import SwiftUI

struct ActiveAlarmOverlay: View {
    var alarm: Olalarm

    var body: some View {
        ScreenPage {
            VStack {
                Spacer()

                VStack(alignment: .center) {
                    Text(alarm.name)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                }

                Spacer()

                VStack(spacing: 40) {
                    if alarm.snooze != nil {
                        ButtonDefault(
                            text: "snooze",
                            systemImage: "zzz",
                            colorText: .white,
                            colorBackground: .colorAccent
                        ) {
                            Task {
                                AlarmManager.snoozeOlalarm(alarm.id)
                            }
                        }
                    }

                    ButtonDefault(
                        text: "stop",
                        systemImage: "stop.circle",
                        colorText: .colorTextPrimary,
                        colorBackground: .colorSurface
                    ) {
                        Task {
                            AlarmManager.cancelOlalarm(alarm.id)
                        }
                    }

                }.padding(.horizontal, 60)

                Spacer()
            }
        }
    }
}

extension View {
    func activeAlarmOverlay(activeAlarm: Olalarm?) -> some View {
        fullScreenCover(isPresented: Binding(get: { activeAlarm != nil }, set: { _ in })) {
            if activeAlarm != nil {
                ActiveAlarmOverlay(alarm: activeAlarm!)
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    ScreenPage {
        ActiveAlarmOverlay(alarm: Olalarm(name: "My alarm with long ass name here to check paddings", trigger: Date.now.asTrigger, snooze: 5))
    }
}
