import Foundation

public enum OlalarmError: Error {
    case maxAlarmsReached
    case cannotSetAlarm(error: Error)
    case databaseError(error: Error)
    case alarmNotFound(id: UUID)
    case unexpected(message: String)
    case noPermissions
}

extension OlalarmError: LocalizedError {
    public var userFriendlyDescription: String {
        switch self {
        case .maxAlarmsReached:
            return "You've reached the maximum number of alarms."
        case .cannotSetAlarm:
            return "Could not set the alarm. Please try again."
        case .databaseError:
            return "Something went wrong saving your alarm. Please try again."
        case .alarmNotFound:
            return "This alarm no longer exists."
        case let .unexpected(message):
            return message
        case .noPermissions:
            return "You need to grant permission to set alarms."
        }
    }

    public var errorDescription: String? {
        switch self {
        case let .alarmNotFound(id: id):
            return "Alarm not found with id: \(id.uuidString)"
        case let .databaseError(error):
            return "Database error: \(error.localizedDescription)"
        case .maxAlarmsReached:
            return "Maximum number of alarms set already reached"
        case let .cannotSetAlarm(error: error):
            return "Could not set alarm: \(error.localizedDescription)"
        case .noPermissions:
            return "AlarmKit permissions are not granted"
        case let .unexpected(message: message):
            return message
        }
    }
}
