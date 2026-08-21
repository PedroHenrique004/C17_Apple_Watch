//
//  HeartRateMonitoringTests.swift
//  Respirapp Watch AppTests
//
//  Simula uma leitura de batimentos subindo (fica alto) e depois
//  voltando ao normal, para validar que o alerta dispara nos
//  momentos certos — sem precisar de um Apple Watch de verdade.
//

import Testing
@testable import Respirapp_Watch_App

// MARK: - Fakes

final class FakeHealthKitService: HealthKitServiceProtocol {

    private(set) var didRequestAuthorization = false
    private(set) var didStopMonitoring = false
    private var onUpdate: ((Int) -> Void)?

    func requestAuthorization() async throws {
        didRequestAuthorization = true
    }

    func startHeartRateMonitoring(onUpdate: @escaping (Int) -> Void) {
        self.onUpdate = onUpdate
    }

    func stopHeartRateMonitoring() {
        didStopMonitoring = true
    }

    func simulateHeartRate(_ bpm: Int) async {
        onUpdate?(bpm)
        try? await Task.sleep(for: .milliseconds(50))
    }
}


final class FakeNotificationService: NotificationServiceProtocol {

    private(set) var didRequestAuthorization = false
    private(set) var elevatedNotifications: [Int] = []
    private(set) var normalNotificationsCount = 0

    func requestAuthorization() async {
        didRequestAuthorization = true
    }

    func notifyHeartRateElevated(bpm: Int) {
        elevatedNotifications.append(bpm)
    }

    func notifyHeartRateNormal() {
        normalNotificationsCount += 1
    }
}

// MARK: - Testes do Use Case (regra de negócio pura)

struct MonitorHeartRateUseCaseTests {

    @Test func bpmAcimaDoLimiteFicaElevado() {
        let useCase = MonitorHeartRateUseCase(elevatedThreshold: 100)

        let state = useCase.evaluate(bpm: 120, currentState: .normal)

        #expect(state.isElevated)
    }

    @Test func bpmSobeEDepoisVoltaAoNormal() {
        let useCase = MonitorHeartRateUseCase(elevatedThreshold: 100)
        var state: HeartRateAlertState = .normal

        // Começa normal.
        state = useCase.evaluate(bpm: 70, currentState: state)
        #expect(state == .normal)

        // Sobe acima do limite → fica elevado.
        state = useCase.evaluate(bpm: 120, currentState: state)
        #expect(state.isElevated)

        // Continua alto → segue elevado (mantendo o startDate original).
        if case .elevated(let firstStartDate, _) = state {
            state = useCase.evaluate(bpm: 130, currentState: state)
            if case .elevated(let secondStartDate, let bpm) = state {
                #expect(secondStartDate == firstStartDate)
                #expect(bpm == 130)
            } else {
                Issue.record("Esperava continuar elevado")
            }
        } else {
            Issue.record("Esperava estado elevado após BPM acima do limite")
        }

        // Volta abaixo do limite → volta ao normal.
        state = useCase.evaluate(bpm: 85, currentState: state)
        #expect(state == .normal)
    }
}

// MARK: - Testes do ViewModel (fluxo completo, com fakes)

struct HeartRateViewModelTests {

    @Test func simulaBatimentoAltoEDepoisVoltandoAoNormal() async throws {
        let healthKitService = FakeHealthKitService()
        let notificationService = FakeNotificationService()
        let viewModel = await HeartRateViewModel(
            healthKitService: healthKitService,
            notificationService: notificationService,
            monitorHeartRateUseCase: MonitorHeartRateUseCase(elevatedThreshold: 110)
        )

        await viewModel.start()
        #expect(healthKitService.didRequestAuthorization)
        #expect(notificationService.didRequestAuthorization)

        // 1. BPM normal → nada deve ser notificado.
        await healthKitService.simulateHeartRate(70)
        #expect(viewModel.bpm == 70)
        #expect(viewModel.alertState == .normal)
        #expect(notificationService.elevatedNotifications.isEmpty)

        // 2. BPM sobe acima do limite → deve notificar "elevado" UMA vez.
        await healthKitService.simulateHeartRate(120)
        #expect(viewModel.alertState.isElevated)
        #expect(notificationService.elevatedNotifications == [120])

        // 3. Continua alto → não deve notificar de novo.
        await healthKitService.simulateHeartRate(135)
        #expect(notificationService.elevatedNotifications == [120])

        // 4. Volta abaixo do limite → deve notificar "normal" UMA vez.
        await healthKitService.simulateHeartRate(80)
        #expect(viewModel.alertState == .normal)
        #expect(notificationService.normalNotificationsCount == 1)

        // 5. Continua normal → não deve notificar de novo.
        await healthKitService.simulateHeartRate(75)
        #expect(notificationService.normalNotificationsCount == 1)
    }
}
