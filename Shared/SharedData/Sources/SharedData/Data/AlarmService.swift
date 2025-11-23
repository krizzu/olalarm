import AlarmKit
import Foundation
import Logging
import SQLiteData

public final actor AlarmService {
    public static let shared = AlarmService(database: AppDatabase.shared)

    private let logger = Logger(label: "olalarm.AlarmService")
    private var database: DatabaseWriter

    private init(database: DatabaseWriter) {
        self.database = database

        Task {
            await syncWithAlarmKit()
            await startObserving()
        }
    }

    private func startObserving() async {
        for await _ in AlarmManager.shared.alarmUpdates {
            await syncWithAlarmKit()
        }
    }

    // function that fetches all AlarmKit's alarms and all olalarms and sync their states
    // deals with out-of sync cases (AlarmKit's alarm enabled, but same id not found in database etc.)
    // returns updated alarms
    private func syncWithAlarmKit() async {
        do {
            let appleAlarms = try AlarmManager.shared.alarms
            let allAlarms = try await database.read { db in
                try Olalarm.all.fetchAll(db)
            }

            var notInDatabase: [UUID] = []
            if appleAlarms.count > allAlarms.count {
                logger.warning("Sync: Alarms are out of sync! kits=\(appleAlarms.count), olalarms=\(allAlarms.count)")
                let ids = allAlarms.map { $0.id }
                notInDatabase = appleAlarms.filter { !ids.contains($0.id) }.map { $0.id }
            }

            var toUpdate: [Olalarm] = []

            for var alarm in allAlarms {
                let appleAlarm = appleAlarms.first(where: { $0.id == alarm.id })

                if appleAlarm == nil, alarm.state != .disabled {
                    logger.debug("Sync: Alarm kit not found for \(alarm.name), disabling")
                    alarm.state = .disabled
                    toUpdate.append(alarm)
                } else if appleAlarm != nil, appleAlarm!.toOlalarmState() != alarm.state {
                    let newState = appleAlarm!.toOlalarmState()
                    logger.debug("Sync: Updating alarm \"\(alarm.name)\" to \"\(newState)\" state")
                    alarm.state = newState
                    toUpdate.append(alarm)
                }
            }

            if toUpdate.count > 0 {
                await updateDbState(toUpdate)
            }

            if notInDatabase.count > 0 {
                logger.warning("Sync: Found \(notInDatabase.count) alarm from alarmkit not in sync, removing",)
                for id in notInDatabase {
                    try? AlarmManager.shared.cancel(id: id)
                }
            }

            await BadgeService.shared.updateBadgeCount()

        } catch {
            logger.error("Something went wrong while reading alarms: \(error.localizedDescription)",)
        }
    }

    private func updateDbState(_ alarms: [Olalarm]) async {
        do {
            try await database.write { db in
                for alarm in alarms {
                    try Olalarm.update(alarm).execute(db)
                }
            }
            logger.info("Sync: Updated db state, count: \(alarms.count)")

        } catch {
            logger.error("Failed to update db state: \(error.localizedDescription)")
        }
    }

    // TODO: make private. the modify screen can fetch it
    public func getAlarm(id: UUID) async throws -> Olalarm? {
        do {
            return try await database.read { db in
                try Olalarm.where { $0.id == id }.limit(1).fetchOne(db)
            }
        } catch {
            throw OlalarmError.databaseError(error: error)
        }
    }

    public func createAlarm(name: String, time: Date, snooze: Int?, enabled: Bool?, soundId: String?) async throws -> Olalarm {
        let scheduled = enabled ?? true
        let alarm = Olalarm(
            id: UUID(),
            name: name,
            trigger: Olalarm.Trigger(hour: time.hour, minute: time.minute),
            enabled: scheduled,
            snooze: snooze,
            soundId: soundId,
        )

        do {
            logger.info("creating alarm \(name)")
            try await AlarmManager.assertPermissions()
            try await database.write { db in
                try Olalarm.insert {
                    alarm
                }.execute(db)
            }
            if scheduled {
                try await AlarmManager.scheduleOlalarm(alarm)
            }

            logger.info("alarm \(name) created")
        } catch let olalarmError as OlalarmError {
            if scheduled {
                // rollback
                AlarmKit.AlarmManager.cancelOlalarm(alarm.id)
            }
            logger.info("cannot create alarm \(alarm.name): \(olalarmError)")
            throw olalarmError
        } catch {
            if scheduled {
                // rollback
                AlarmKit.AlarmManager.cancelOlalarm(alarm.id)
            }
            logger.info("cannot create alarm \(name): \(error)")
            throw OlalarmError.databaseError(error: error)
        }

        return alarm
    }

    public func updateAlarm(alarm: Olalarm) async throws -> Olalarm {
        do {
            try await AlarmManager.assertPermissions()
            try await database.write { db in
                try Olalarm.update(alarm).execute(db)
            }

            if alarm.enabled {
                AlarmKit.AlarmManager.cancelOlalarm(alarm.id)
                try await AlarmKit.AlarmManager.scheduleOlalarm(alarm)
            } else {
                AlarmKit.AlarmManager.cancelOlalarm(alarm.id)
            }
            logger.info("alarm \(alarm.name) updated and \(alarm.enabled ? "enabled" : "disabled")")
        } catch let olalarmError as OlalarmError {
            logger.info("cannot update alarm \(alarm.name): \(olalarmError)")
            throw olalarmError
        } catch {
            logger.info("cannot update alarm \(alarm.name): \(error)")
            throw OlalarmError.databaseError(error: error)
        }

        return alarm
    }

    public func removeAlarm(id: UUID) async throws {
        guard let alarm = try await getAlarm(id: id) else {
            throw OlalarmError.alarmNotFound(id: id)
        }

        do {
            try await AlarmManager.assertPermissions()
            AlarmManager.cancelOlalarm(alarm.id)
            try await database.write { db in
                try Olalarm.delete(alarm).execute(db)
            }
            logger.info("alarm \(alarm.name) removed")
        } catch let error as OlalarmError {
            logger.error("cannot remove alarm \(alarm.name): \(error)")
            throw error
        } catch {
            logger.info("cannot remove alarm \(alarm.name): \(error)")
            throw OlalarmError.databaseError(error: error)
        }
    }
}

extension Alarm {
    func toOlalarmState() -> Olalarm.State {
        switch state {
        case .alerting:
            return .alerting
        case .countdown:
            return .snooze
        default:
            return .scheduled
        }
    }
}
