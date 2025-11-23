import AlarmKit
import Foundation
import SharedData
import SQLiteData
import SwiftUI

@Observable
class ModifyAlarmViewModel {
    @ObservationIgnored
    private var alarmsServices = AlarmService.shared

    func find(id: UUID) async -> Result<Olalarm, OlalarmError> {
        do {
            if let alarm = try await alarmsServices.getAlarm(id: id) {
                return .success(alarm)
            }
            return .failure(.alarmNotFound(id: id))
        } catch let error as OlalarmError {
            return .failure(error)
        } catch {
            return .failure(.unexpected(message: error.localizedDescription))
        }
    }

    func create(name: String, timeTrigger: Date, enabled: Bool, snooze: Int?, soundId: String?) async -> Result<Olalarm, OlalarmError> {
        do {
            let alarm = try await alarmsServices.createAlarm(name: name, time: timeTrigger, snooze: snooze, enabled: enabled, soundId: soundId)
            return .success(alarm)
        } catch let error as OlalarmError {
            return .failure(error)
        } catch {
            return .failure(.unexpected(message: error.localizedDescription))
        }
    }

    func save(id: UUID, name: String, timeTrigger: Date, enabled: Bool, snooze: Int?, soundId: String?) async -> Result<Olalarm, OlalarmError> {
        do {
            guard var alarm = try await alarmsServices.getAlarm(id: id) else {
                throw OlalarmError.alarmNotFound(id: id)
            }
            alarm.name = name
            alarm.trigger = timeTrigger.asTrigger
            alarm.state = enabled ? .scheduled : .disabled
            alarm.snooze = snooze
            alarm.soundId = soundId

            let updated = try await alarmsServices.updateAlarm(alarm: alarm)
            return .success(updated)

        } catch let error as OlalarmError {
            return .failure(error)
        } catch {
            return .failure(.unexpected(message: error.localizedDescription))
        }
    }
}
