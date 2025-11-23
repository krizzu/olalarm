import SharedData
import SwiftUI

struct AlarmView: View {
    var alarm: Olalarm
    var small: Bool = false // rearrange things based on size
    var onToggle: (Bool) -> Void

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        VStack(spacing: small ? 12 : 0) {
            if small {
                smallTop
            } else {
                largeTop
            }
            
            if(!small) {
                Spacer()
            }

            if small {
                smallBottom
            } else {
                largeBottom
            }
        }
        .padding()
        .background(.colorSurface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.colorAccent.opacity(0.3), lineWidth: 1)
        ).opacity(alarm.enabled ? 1 : 0.8)
    }

    var largeTop: some View {
        HStack(spacing: 0) {
            Text(alarm.name)
                .font(.headline.weight(.regular))
                .foregroundColor(.colorTextPrimary)
            Spacer()
            Toggle("", isOn: Binding(get: {
                alarm.enabled
            }, set: { isOn in
                onToggle(isOn)
            }))
            .tint(.colorPrimary)
            .labelsHidden()
        }
    }

    var smallTop: some View {
        HStack(spacing: 0) {
            if let snooze = alarm.snooze {
                let t = snooze > 1 ? "mins" : "min"
                HStack(spacing: 2) {
                    Image(systemName: "zzz").foregroundStyle(.colorTextPrimary)
                    Text("\(snooze) \(t)").font(.caption.bold()).foregroundStyle(.colorTextPrimary)
                }
            }
            Spacer()
            Toggle("", isOn: Binding(get: {
                alarm.enabled
            }, set: { isOn in
                onToggle(isOn)
            }))
            .tint(.colorPrimary)
            .labelsHidden()
        }
    }

    var largeBottom: some View {
        HStack {
            Text(alarm.trigger)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.colorTextPrimary)

            Spacer()
            if let snooze = alarm.snooze {
                let t = snooze > 1 ? "mins" : "min"
                HStack(spacing: 2) {
                    Image(systemName: "zzz").foregroundStyle(.colorTextPrimary)
                    Text("\(snooze) \(t)").font(.caption.bold()).foregroundStyle(.colorTextPrimary)
                }
            }
        }
    }

    var smallBottom: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text(alarm.name)
                    .font(.headline.weight(.regular))
                    .foregroundColor(.colorTextPrimary)
                    .multilineTextAlignment(.leading)
            }.frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading) {
                Text(alarm.trigger)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.colorTextPrimary)
                    .multilineTextAlignment(.leading)
            }.frame(maxWidth: .infinity, alignment: .leading)

        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension Olalarm {
    static func mock(title: String) -> Olalarm {
        Olalarm(id: UUID(), name: title, trigger: Date.asTrigger, enabled: Bool.random(), snooze: Int.random(in: 0 ... 5))
    }
}

#Preview("2 per row") {
    ScreenPage {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]) {
            ForEach([
                Olalarm.mock(title: "alarm 1"),
                Olalarm.mock(title: "alarm 2"),
                Olalarm.mock(title: "alarm 3"),
            ]) { alarm in
                AlarmView(alarm: alarm, small: true, onToggle: { _ in })
            }
        }.padding(.horizontal, 12)
    }
}

#Preview("1 per row") {
    ScreenPage {
        LazyVGrid(columns: [
            GridItem(.flexible()),
        ]) {
            ForEach([
                Olalarm.mock(title: "alarm 1"),
                Olalarm.mock(title: "alarm 2"),
                Olalarm.mock(title: "alarm 3"),
            ]) { alarm in
                AlarmView(alarm: alarm, small: false, onToggle: { _ in })
            }
        }.padding(.horizontal, 12)
    }
}
