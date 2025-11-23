import SwiftUI
import Foundation

struct TimerText: View {
    let range: ClosedRange<Date>

    var body: some View {
        TimelineView(.periodic(from: range.lowerBound, by: 1)) { context in
            Text(Self.format(context.date, in: range))
        }
    }

    static func format(_ current: Date, in range: ClosedRange<Date>) -> String {
        let remaining = range.upperBound.timeIntervalSince(current)
        if remaining <= 0 {
            return "-"
        } else {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .abbreviated
            return formatter.string(from: remaining) ?? ""
        }
    }
}

