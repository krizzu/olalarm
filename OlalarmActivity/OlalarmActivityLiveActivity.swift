import ActivityKit
import AlarmKit
import AppIntents
import SharedData
import SwiftUI
import WidgetKit

struct OlalarmActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributes<OlalarmMeta>.self) { context in
            lockScreenView(attr: context.attributes, state: context.state)
                .activityBackgroundTint(.colorSurface)
                .activitySystemActionForegroundColor(.accentColor)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    dynamicIslandView(type: .leading, attr: context.attributes, state: context.state)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    dynamicIslandView(type: .trailing, attr: context.attributes, state: context.state)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    dynamicIslandView(type: .bottom, attr: context.attributes, state: context.state)
                }
            } compactLeading: {
                dynamicIslandView(type: .compactLeading, attr: context.attributes, state: context.state)
            } compactTrailing: {
                dynamicIslandView(type: .compactTrailing, attr: context.attributes, state: context.state)
            } minimal: {
                dynamicIslandView(type: .minimal, attr: context.attributes, state: context.state)
            }
            .keylineTint(.colorAccent)
        }
    }
}

enum DynamicIslandType {
    case leading, trailing, bottom, compactLeading, compactTrailing, minimal
}

func dynamicIslandView(type: DynamicIslandType, attr: AlarmAttributes<OlalarmMeta>, state: AlarmPresentationState) -> some View {
    return Group {
        switch type {
        case .leading:
            Group {
                switch state.mode {
                case .countdown:
                    Image(systemName: "zzz").foregroundStyle(.colorPrimary)
                default:
                    EmptyView()
                }
            }.padding(.all, 12)

        case .trailing:
            Group {
                Image("olalarm_icon_small")
                    .scaledToFit()
                    .frame(width: 45)
            }.padding(.trailing, 12)

        case .bottom:
            lockScreenView(attr: attr, state: state)

        case .compactLeading:
            Group {
                switch state.mode {
                case .countdown:
                    Image(systemName: "zzz").foregroundStyle(.colorPrimary)
                default:
                    Image("olalarm_icon_minimal")
                        .resizable()
                        .scaledToFit()
                }
            }.padding(.leading, 6)

        case .compactTrailing:
            switch state.mode {
            case .countdown:
                countdown(state: state)
                    .multilineTextAlignment(.trailing)
            default:
                Text(attr.presentation.alert.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

        case .minimal:
            Group {
                Image("olalarm_icon_minimal")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

func lockScreenView(attr: AlarmAttributes<OlalarmMeta>, state: AlarmPresentationState) -> some View {
    return HStack {
        VStack {
            Text(attr.presentation.alert.title)
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .truncationMode(.tail)
            countdown(state: state)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 40, design: .rounded))
        }
        Spacer()
        AlarmControls(presentation: attr.presentation, state: state)
    }.padding(.all, 12)
}

func countdown(state: AlarmPresentationState) -> some View {
    Group {
        switch state.mode {
        case let .countdown(countdown):
            Text(timerInterval: Date.now ... countdown.fireDate, countsDown: true)
        default:
            EmptyView()
        }
    }
    .monospacedDigit()
    .lineLimit(1)
    .minimumScaleFactor(0.6)
}

#Preview(
    as: .content,
    using: AlarmAttributes.mock,
    widget: { OlalarmActivityLiveActivity() },
    contentStates: {
        AlarmPresentationState.mock_countdown
    }
)

#Preview(
    as: .content,
    using: AlarmAttributes.mock,
    widget: { OlalarmActivityLiveActivity() },
    contentStates: {
        AlarmPresentationState.mock_alert
    }
)

extension AlarmAttributes where Metadata == OlalarmMeta {
    static var mock: AlarmAttributes<OlalarmMeta> {
        let alarm = Olalarm(name: "mock alarm with super long text actually", trigger: Date.now.advanced(by: 60).asTrigger, snooze: 5)
        return AlarmManager.createAttributes(alarm: alarm)
    }
}

extension AlarmPresentationState {
    static var mock_countdown: AlarmPresentationState {
        AlarmPresentationState(
            alarmID: UUID(),
            mode: .countdown(.init(totalCountdownDuration: 5.0, previouslyElapsedDuration: 1.0, startDate: .now.addingTimeInterval(50), fireDate: .now.addingTimeInterval(10 + 60)))
        )
    }

    static var mock_alert: AlarmPresentationState {
        AlarmPresentationState(
            alarmID: UUID(),
            mode: .alert(.init(time: .init(hour: 5, minute: 5)))
        )
    }
}
