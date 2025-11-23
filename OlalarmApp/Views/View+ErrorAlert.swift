import SharedData
import SwiftUI

extension View {
    func errorAlert(error: Binding<OlalarmError?>, buttonTitle: String = "OK") -> some View {
        let realError = error.wrappedValue
        return alert(isPresented: .constant(realError != nil), error: LocalizedAlertError(error: realError)) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { _ in
            Text(realError?.userFriendlyDescription ?? "")
        }
    }
}

private struct LocalizedAlertError: LocalizedError {
    
    private var title: String
    
    var errorDescription: String? {
        return title
    }

    init?(error: OlalarmError?) {
        guard let localizedError = error else { return nil }

        var title = "Something went wrong"
        switch localizedError {
        case .alarmNotFound:
            title = "Alarm not found"
        case .cannotSetAlarm, .maxAlarmsReached:
            title = "Cannot set alarm"
        case .databaseError:
            title = "Database error"
        case .noPermissions:
            title = "Permissions required"
        case .unexpected:
            title = "Unexpected error"
        }
        self.title = title
    }
}
