import AlarmKit
import Foundation
import SharedData
import SQLiteData
import SwiftUI

@Observable
@MainActor
class HomeViewModel {
    @ObservationIgnored
    private var service = AlarmService.shared

    @ObservationIgnored
    @FetchAll
    var alarms: [Olalarm]

    func toggle(_ olalarm: Olalarm) async -> Result<Olalarm, OlalarmError> {
        var alarm = olalarm
        alarm.state = alarm.enabled ? .disabled : .scheduled
        do {
            let alarm = try await service.updateAlarm(alarm: alarm)
            return .success(alarm)
        } catch let error as OlalarmError {
            return .failure(error)
        } catch {
            return .failure(OlalarmError.unexpected(message: error.localizedDescription))
        }
    }

    func delete(alarm: Olalarm) async -> Result<Void, OlalarmError> {
        do {
            try await service.removeAlarm(id: alarm.id)
            return .success(())
        } catch let error as OlalarmError {
            return .failure(error)
        } catch {
            return .failure(OlalarmError.unexpected(message: error.localizedDescription))
        }
    }
}
