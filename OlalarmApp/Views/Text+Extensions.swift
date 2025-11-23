import SwiftUI
import SharedData

extension Text {
    // a text view that properly renders alarm's trigger time
    init(_ alarm: Olalarm.Trigger) {
        let h = alarm.hour < 10 ? "0" + String(alarm.hour) : String(alarm.hour)
        let m = alarm.minute < 10 ? "0" + String(alarm.minute) : String(alarm.minute)
        self.init("\(h):\(m)")
    }
}
