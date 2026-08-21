//
//  MonitorHeartRateUseCase.swift
//  Respirapp Watch App
//
//  Use Case responsável por decidir, a partir de uma leitura de BPM,
//  qual o novo estado de alerta da frequência cardíaca.
//
//  Essa é a regra de negócio de "batimento alto" que antes estava
//  hardcoded na View (HealthWorkout.swift).
//

import Foundation

protocol MonitorHeartRateUseCaseProtocol {
    func evaluate(bpm: Int, currentState: HeartRateAlertState) -> HeartRateAlertState
}

struct MonitorHeartRateUseCase: MonitorHeartRateUseCaseProtocol {

    private let elevatedThreshold: Int

    init(elevatedThreshold: Int = Constants.elevatedHeartRateThreshold) {
        self.elevatedThreshold = elevatedThreshold
    }

    func evaluate(bpm: Int, currentState: HeartRateAlertState) -> HeartRateAlertState {
        let isElevated = bpm >= elevatedThreshold

        guard isElevated else {
            return .normal
        }

        if case .elevated(let startDate, _) = currentState {
            return .elevated(startDate: startDate, bpm: bpm)
        }

        return .elevated(startDate: Date(), bpm: bpm)
    }
}
