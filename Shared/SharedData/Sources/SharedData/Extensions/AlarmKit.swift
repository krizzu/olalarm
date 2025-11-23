import ActivityKit
import AlarmKit
import AppIntents
import Logging
import SQLiteData
import SwiftUI

public struct OlalarmMeta: AlarmMetadata {
    public var name: String
}

private func assertPermissions() throws {
    let state = AlarmManager.shared.authorizationState
    if state == .denied {
        throw OlalarmError.noPermissions
    }
}

private let log = Logger(label: "olalarm.AlarmManager")
public extension AlarmManager {
    static func assertPermissions() async throws {
        guard let permissions = try? await AlarmManager.shared.requestAuthorization() else {
            throw OlalarmError.noPermissions
        }

        if permissions != .authorized {
            throw OlalarmError.noPermissions
        }
    }

    static func scheduleOlalarm(_ alarm: Olalarm) async throws {
        do {
            try await assertPermissions()
            let configuration = createAlarmKitConfiguration(for: alarm)
            _ = try await AlarmManager.shared.schedule(id: alarm.id, configuration: configuration)
            log.info("\(alarm.name) scheduled")
        } catch let olalarmError as OlalarmError {
            throw olalarmError
        } catch (AlarmManager.AlarmError.maximumLimitReached) {
            log.warning("\(alarm.name) cannot be scheduled, max alarm limit")
            throw OlalarmError.maxAlarmsReached
        } catch {
            log.warning("\(alarm.name) cannot be scheduled: \(error)")
            throw OlalarmError.cannotSetAlarm(error: error)
        }
    }

    static func snoozeOlalarm(_ id: UUID) {
        do {
            try AlarmManager.shared.countdown(id: id)
            log.info("Alarm \(id) snoozed")
        } catch {
            log.warning("Could not snooze alarm (\(id)): \(error)")
        }
    }

    static func cancelOlalarm(_ id: UUID) {
        do {
            try AlarmManager.shared.cancel(id: id)
            log.info("Alarm \(id) cancelled")
        } catch {
            log.warning("Could not cancel alarm (\(id)): \(error)")
        }
    }

    private static func createAlarmKitConfiguration(for alarm: Olalarm) -> AlarmManager.AlarmConfiguration<OlalarmMeta> {
        let sound = alarm.sound
        return AlarmManager.AlarmConfiguration(
            countdownDuration: createCountdownDuration(alarm: alarm),
            schedule: createRelativeSchedule(alarm: alarm),
            attributes: createAttributes(alarm: alarm),
            stopIntent: OlalarmAppIntents.Stop(alarmID: alarm.id.uuidString),
            secondaryIntent: nil,
            sound: sound != nil ? .named(sound!.fileName) : .default
        )
    }

    // An object that contains all information necessary for the alarm UI.
    static func createAttributes(alarm: Olalarm) -> AlarmAttributes<OlalarmMeta> {
        let stopButton = AlarmButton(text: "Stop", textColor: .colorTextPrimary, systemImageName: "stop.circle")

        var snoozeButton: AlarmButton? = nil
        if alarm.snooze != nil {
            snoozeButton = AlarmButton(text: "Snooze", textColor: .accentColor, systemImageName: "zzz")
        }

        let alertPresentation = AlarmPresentation.Alert(
            title: LocalizedStringResource(stringLiteral: alarm.name),
            stopButton: stopButton,
            secondaryButton: snoozeButton,
            secondaryButtonBehavior: (snoozeButton != nil) ? .countdown : nil,
        )

        let presentation = AlarmPresentation(alert: alertPresentation)

        let alarmAttributes = AlarmAttributes<OlalarmMeta>(presentation: presentation, metadata: nil, tintColor: .white)
        return alarmAttributes
    }

    // An object that defines the durations used in an alarm that has a countdown.
    // here, only postAlert countdown is set, for duration of snooze
    private static func createCountdownDuration(alarm: Olalarm) -> Alarm.CountdownDuration? {
        guard let snooze = alarm.snooze else { return nil }
        return .init(preAlert: nil, postAlert: TimeInterval(snooze * 60))
    }

    // creates relative, one off schedule, to fire at specified hour and time
    private static func createRelativeSchedule(alarm: Olalarm) -> Alarm.Schedule {
        let time = Alarm.Schedule.Relative.Time(hour: alarm.trigger.hour, minute: alarm.trigger.minute)
        let relativeSchedule = Alarm.Schedule.Relative(time: time, repeats: .never)
        return Alarm.Schedule.relative(relativeSchedule)
    }
}

extension Color {
    static var colorTextPrimary: Color {
        Color("ColorTextPrimary", bundle: .module)
    }

    static var colorBackground: Color {
        Color("ColorBackground", bundle: .module)
    }

    static var colorPrimary: Color {
        Color("ColorPrimary", bundle: .module)
    }

    static var colorAccent: Color {
        Color("ColorAccent", bundle: .module)
    }

    static var colorSurface: Color {
        Color("ColorSurface", bundle: .module)
    }
}
