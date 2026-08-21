//
//  HeartRateAlertState.swift
//  Respirapp Watch App
//
//  Representa o estado de alerta da frequência cardíaca do usuário.
//  Faz parte da camada de Domínio: não conhece HealthKit, notificações
//  ou SwiftUI, apenas a regra de negócio.
//

import Foundation

enum HeartRateAlertState: Equatable {

    /// Frequência cardíaca dentro do esperado.
    case normal

    /// Frequência cardíaca acima do limite definido, desde `startDate`.
    case elevated(startDate: Date, bpm: Int)

    /// Indica se o estado atual representa uma elevação nos batimentos.
    var isElevated: Bool {
        if case .elevated = self {
            return true
        }
        return false
    }
}
