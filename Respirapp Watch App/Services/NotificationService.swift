//
//  NotificationService.swift
//  Respirapp Watch App
//
//  Camada de dados: encapsula o envio de notificações locais.
//

import Foundation
import UserNotifications
import WatchKit

protocol NotificationServiceProtocol {
    func requestAuthorization() async
    func notifyHeartRateElevated(bpm: Int)
    func notifyHeartRateNormal()
    func playHaptic(type: WKHapticType)
}

final class NotificationService: NotificationServiceProtocol {

    private let center = UNUserNotificationCenter.current()

    func requestAuthorization() async {
        do {
            try await center.requestAuthorization(options: [.alert, .sound])
        } catch {
            print(error)
        }
    }
    
    // MARK: - Haptics
    func playHaptic(type: WKHapticType) {
        guard UserPreferencesStore.shared.isHapticsEnabled else { return }
        WKInterfaceDevice.current().play(type)
    }

    func notifyHeartRateElevated(bpm: Int) {
        guard UserPreferencesStore.shared.isNotificationsEnabled else { return }
        
        send(
            title: "Frequência cardíaca elevada",
            body: "Seus batimentos estão em \(bpm) bpm."
        )
    }

    func notifyHeartRateNormal() {
        guard UserPreferencesStore.shared.isNotificationsEnabled else { return }
        
        send(
            title: "Frequência cardíaca normalizada",
            body: "Seus batimentos voltaram ao normal."
        )
    }

    private func send(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        center.add(request) { error in
            if let error {
                print(error)
            }
        }
    }
}
