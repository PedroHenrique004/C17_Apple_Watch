//
//  NotificationService.swift
//  Respirapp Watch App
//
//  Camada de dados: encapsula o envio de notificações locais.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func requestAuthorization() async
    func notifyHeartRateElevated(bpm: Int)
    func notifyHeartRateNormal()
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

    func notifyHeartRateElevated(bpm: Int) {
        send(
            title: "Frequência cardíaca elevada",
            body: "Seus batimentos estão em \(bpm) bpm."
        )
    }

    func notifyHeartRateNormal() {
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
