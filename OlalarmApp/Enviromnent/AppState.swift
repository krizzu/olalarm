import AlarmKit
import Logging
import Observation
import SharedData
import SQLiteData

@Observable
class AppState {
    @ObservationIgnored
    @FetchOne(Olalarm.where { $0.state == Olalarm.State.alerting })
    var activeAlarm: Olalarm?
}
