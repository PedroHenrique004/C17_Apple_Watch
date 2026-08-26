//
//  HeartRateViewModel.swift
//  Respirapp Watch App
//
//  Camada de apresentação: orquestra o HealthKitService, o Use Case
//  de monitoramento e o NotificationService, expondo um estado simples
//  para a HeartRateView consumir.
//

import Foundation
import Observation

@Observable
final class HeartRateViewModel {

    private(set) var bpm = 0
    private(set) var alertState: HeartRateAlertState = .normal
    private(set) var errorMessage: String? = nil

    private let healthKitService: HealthKitServiceProtocol
    private let notificationService: NotificationServiceProtocol
    private let monitorHeartRateUseCase: MonitorHeartRateUseCaseProtocol
    
    init(
        healthKitService: HealthKitServiceProtocol = HealthKitService(),
        notificationService: NotificationServiceProtocol = NotificationService(),
        monitorHeartRateUseCase: MonitorHeartRateUseCaseProtocol = MonitorHeartRateUseCase()
    ) {
        self.healthKitService = healthKitService
        self.notificationService = notificationService
        self.monitorHeartRateUseCase = monitorHeartRateUseCase
    }

    func start() async {
        healthKitService.startHeartRateMonitoring(onUpdate: { [weak self] bpm in
            Task { @MainActor in
                self?.handleHeartRateUpdate(bpm)
                self?.errorMessage = nil
            }
        }, onError: { [weak self] errorMsg in
            Task { @MainActor in
                self?.errorMessage = "HealthKit Error: \(errorMsg)"
            }
        })
    }
    
    func stop() {
        healthKitService.stopHeartRateMonitoring()
    }

    @MainActor
    private func handleHeartRateUpdate(_ currentBPM: Int) {
        bpm = currentBPM

        let previousState = alertState
        let newState = monitorHeartRateUseCase.evaluate(bpm: currentBPM, currentState: previousState)
        alertState = newState

        guard newState.isElevated != previousState.isElevated else {
            return
        }

        if newState.isElevated {
            notificationService.notifyHeartRateElevated(bpm: currentBPM)
        } else {
            notificationService.notifyHeartRateNormal()
        }
    }
}
