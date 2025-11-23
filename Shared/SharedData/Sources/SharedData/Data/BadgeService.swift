import AlarmKit
import Logging
import NotificationCenter
import SwiftUI

@MainActor
public class BadgeService {
    public static let shared: BadgeService = .init()

    @MainActor
    public private(set) var hasPermissions: Bool = false

    private init() {}

    private let log = Logger(label: "BadgeService")

    private var isEnabled: Bool {
        UserDefaults.standard.object(forKey: AppSettings.KeyBadge) as? Bool ?? false
    }

    @MainActor private func updateBadgeCount(_ count: Int) {
        UNUserNotificationCenter.current().setBadgeCount(count)
    }

    private func scheduleUpdateBadgeCount(_ count: Int) async {
        let content = UNMutableNotificationContent()
        content.badge = NSNumber(value: count)
        content.sound = nil
        content.title = "" // invisible
        content.body = "" // invisible

        let request = UNNotificationRequest(
            identifier: "badge.update",
            content: content,
            trigger: nil // deliver immediately
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            log.warning("Could not schedule badge update")
        }
    }

    public func requestPermissions() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        guard settings.authorizationStatus != .authorized else {
            hasPermissions = true
            return true
        }

        do {
            let granted = try await center.requestAuthorization(options: [.badge])
            hasPermissions = granted
            return granted
        } catch {
            log.warning("Notification permission request failed: \(error)")
            return false
        }
    }

    // convinence function
    private func setOrSchedule(_ count: Int) async {
        await MainActor.run {
            UNUserNotificationCenter.current().setBadgeCount(count)
        }
        // fallback
        await scheduleUpdateBadgeCount(count)
    }

    private func assertEnabledWithPermissions() async -> Bool? {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        let status = settings.authorizationStatus

        if !isEnabled {
            if status != .notDetermined {
                log.info("feature disabled")
                await setOrSchedule(0)
            }
            return nil
        }

        if isEnabled, status != .authorized {
            if !(await requestPermissions()) {
                log.warning("cannot update badge count, no permissions")
                return nil
            }
        }

        return true
    }

    public func updateBadgeCount() async {
        guard let _ = await assertEnabledWithPermissions() else {
            return
        }

        guard let count = try? AlarmManager.shared.alarms.count else {
            log.warning("cannot update badge count, cannot read alarms")
            return
        }

        await setOrSchedule(count)
    }
}
