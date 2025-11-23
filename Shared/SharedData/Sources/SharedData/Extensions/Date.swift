import Foundation

extension Date {
    public var hour: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: self)
        return components.hour ?? 0
    }

    public var minute: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: self)
        return components.minute ?? 0
    }

    public var asTrigger: Olalarm.Trigger {
        Olalarm.Trigger(hour: hour, minute: minute)
    }

    public static var asTrigger: Olalarm.Trigger {
        Date.now.asTrigger
    }
}
