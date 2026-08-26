import Foundation
import Observation
import WidgetKit

@Observable
final class HeartRateViewModel {

    private(set) var bpm = 0
    private(set) var alertState: HeartRateAlertState = .normal
    private(set) var errorMessage: String? = nil

    private let healthKitService: HealthKitServiceProtocol
    private let notificationService: NotificationServiceProtocol
    private let monitorHeartRateUseCase: MonitorHeartRateUseCaseProtocol
    
    private let appGroupID = "group.dev.pedrosantos.Respirapp"

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

        // --- ATUALIZAÇÃO DO WIDGET ---
        updateWidgetData(currentBPM: currentBPM)

        guard newState.isElevated != previousState.isElevated else {
            return
        }

        if newState.isElevated {
            notificationService.notifyHeartRateElevated(bpm: currentBPM)
        } else {
            notificationService.notifyHeartRateNormal()
        }
    }
        
    @MainActor
    private func updateWidgetData(currentBPM: Int) {
        guard let sharedDefaults = UserDefaults(suiteName: appGroupID) else { return }
        
        let state = calculateState(bpm: currentBPM)
        let quote = getIncentiveQuote(for: state)
        
        sharedDefaults.set(state, forKey: "widgetState")
        sharedDefaults.set(currentBPM, forKey: "widgetBPM")
        sharedDefaults.set(quote, forKey: "widgetQuote")
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func calculateState(bpm: Int) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let isNightTime = hour >= 22 || hour < 6
        
        if bpm < 60 && isNightTime {
            return "Hora de dormir"
        } else if bpm < 75 {
            return "Relaxado"
        } else if bpm <= 95 {
            return "Moderado"
        } else {
            return "Elevado"
        }
    }
    
    private func getIncentiveQuote(for state: String) -> String {
        switch state {
        case "Hora de dormir":
            return "Seu corpo está desacelerando. Tenha uma ótima noite!"
        case "Relaxado":
            return "Você está se saindo bem! Mantenha a calma."
        case "Moderado":
            return "Ritmo estável. Continue respirando fundo."
        case "Elevado":
            return "Que tal fazer uma pausa para respirar agora?"
        default:
            return "Mantenha o foco na sua respiração."
        }
    }
}
