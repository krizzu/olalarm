import Foundation
import SQLiteData

@Table("olalarms")
public struct Olalarm: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var name: String
    @Column("trigger_time", as: Trigger.JSONRepresentation.self)
    public var trigger: Trigger
    public var snooze: Int? = nil // in minutes
    @Column("sound_id")
    public var soundId: String? = nil // OlalarmSound.id
    @Column("created_at")
    public var createdAt: Date = .now
    public var state: State = .scheduled

    public var enabled: Bool {
        return state != .disabled
    }

    public init(id: UUID = UUID(), name: String, trigger: Olalarm.Trigger, enabled: Bool = true, snooze: Int? = nil, soundId: String? = nil) {
        self.id = id
        self.name = name
        self.trigger = trigger
        state = enabled ? .scheduled : .disabled
        self.snooze = snooze
        self.soundId = soundId
    }

    public struct Trigger: Hashable, Codable, Sendable {
        public var hour: Int
        public var minute: Int

        public init(hour: Int, minute: Int) {
            self.hour = hour
            self.minute = minute
        }
    }

    public enum State: String, QueryBindable, Sendable {
        case disabled, // alarm is not set
             scheduled, //  == Alarm.State.scheduled, Alarm.State.paused, as pausing is not supported
             alerting, // == AlarmState.State.alerting
             snooze // AlarmState.State.countdown
    }
}

public extension Olalarm {
    var sound: OlalarmSound? {
        guard let soundId = soundId else { return nil }
        return OlalarmSounds.first(where: { $0.id == soundId })
    }
}

public extension Olalarm.Trigger {
    var description: String {
        return "\(hour):\(minute)"
    }

    func relativeDate(from now: Date = Date()) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = .current // ensures correct timezone

        // Create a DateComponents for today’s date but with the trigger’s hour & minute
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = hour
        components.minute = minute

        let todayDate = calendar.date(from: components)!

        // If that time is already passed today, schedule it for tomorrow
        if todayDate <= now {
            return calendar.date(byAdding: .day, value: 1, to: todayDate)!
        } else {
            return todayDate
        }
    }
}
