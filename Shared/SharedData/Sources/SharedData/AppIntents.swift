import ActivityKit
import AlarmKit
import AppIntents

public enum OlalarmAppIntents {
    public struct Stop: LiveActivityIntent {
        public func perform() async throws -> some IntentResult {
            let id = UUID(uuidString: alarmID)!
            AlarmManager.cancelOlalarm(id)
            await BadgeService.shared.updateBadgeCount()
            return .result()
        }

        public static let title: LocalizedStringResource = "Stop"
        public static let description = IntentDescription("Stop an alarm")

        @Parameter(title: "alarmID")
        var alarmID: String

        public init(alarmID: UUID) {
            self.alarmID = alarmID.uuidString
        }

        public init(alarmID: String) {
            self.alarmID = alarmID
        }

        public init() {
            alarmID = ""
        }
    }

    public struct Snooze: LiveActivityIntent {
        public func perform() throws -> some IntentResult {
            let id = UUID(uuidString: alarmID)!
            AlarmManager.snoozeOlalarm(id)
            return .result()
        }

        public static let title: LocalizedStringResource = "Snooze"
        public static let description = IntentDescription("Snooze an alarm")

        @Parameter(title: "alarmID")
        var alarmID: String

        public init(alarmID: String) {
            self.alarmID = alarmID
        }

        public init() {
            alarmID = ""
        }
    }
}
