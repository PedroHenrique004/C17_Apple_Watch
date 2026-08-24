//
//  HealthKitService.swift
//  Respirapp Watch App
//
//  Camada de dados: encapsula toda a comunicação com o HealthKit.
//  Não conhece regras de negócio (ex: o que é "batimento alto") nem
//  SwiftUI — apenas coleta e expõe os dados de frequência cardíaca.
//

import Foundation
import HealthKit

protocol HealthKitServiceProtocol: AnyObject {
    func requestAuthorization() async throws
    func startHeartRateMonitoring(onUpdate: @escaping (Int) -> Void, onError: @escaping (String) -> Void)
    func stopHeartRateMonitoring()
}

final class HealthKitService: NSObject, HealthKitServiceProtocol {

    enum HealthKitServiceError: Error {
        case heartRateTypeUnavailable
    }

    private let healthStore = HKHealthStore()

    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?

    private var onHeartRateUpdate: ((Int) -> Void)?
    private var onError: ((String) -> Void)?

    private var workoutConfiguration: HKWorkoutConfiguration {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .unknown
        return configuration
    }

    private var heartRateType: HKQuantityType? {
        HKQuantityType.quantityType(forIdentifier: .heartRate)
    }

    // MARK: - Authorization

    func requestAuthorization() async throws {
        guard let heartRateType else {
            throw HealthKitServiceError.heartRateTypeUnavailable
        }

        try await healthStore.requestAuthorization(
            toShare: [HKQuantityType.workoutType()],
            read: [heartRateType]
        )
    }

    // MARK: - Start / Stop Workout

    func startHeartRateMonitoring(onUpdate: @escaping (Int) -> Void, onError: @escaping (String) -> Void) {
        self.onHeartRateUpdate = onUpdate
        self.onError = onError

        do {
            let session = try HKWorkoutSession(
                healthStore: healthStore,
                configuration: workoutConfiguration
            )
            
            session.delegate = self

            let builder = session.associatedWorkoutBuilder()

            builder.delegate = self
            let dataSource = HKLiveWorkoutDataSource(
                healthStore: healthStore,
                workoutConfiguration: workoutConfiguration
            )
            
            if let heartRateType {
                dataSource.enableCollection(for: heartRateType, predicate: nil)
            }
            
            builder.dataSource = dataSource

            workoutSession = session
            workoutBuilder = builder

            let startDate = Date()

            session.startActivity(with: startDate)

            builder.beginCollection(withStart: startDate) { success, error in
                if let error {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }

    func stopHeartRateMonitoring() {
        workoutSession?.end()
        workoutBuilder?.endCollection(withEnd: Date()) { [weak self] _, error in
            if let error {
                print(error)
            }
            self?.workoutSession = nil
            self?.workoutBuilder = nil
        }
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate

// O Delegate recebe atualizações do HKLiveWorkoutBuilder.
extension HealthKitService: HKLiveWorkoutBuilderDelegate {

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }

    /*
     É chamado quando o Builder recebe novos dados.

     collectedTypes informa quais tipos de dados foram
     atualizados naquele momento.
    */
    func workoutBuilder(
        _ workoutBuilder: HKLiveWorkoutBuilder,
        didCollectDataOf collectedTypes: Set<HKSampleType>
    ) {
        print("workoutBuilder didCollectDataOf: \(collectedTypes)")
        
        guard let heartRateType else {
            print("heartRateType is nil")
            return
        }
        
        guard let statistics = workoutBuilder.statistics(for: heartRateType) else {
            print("No statistics for heart rate")
            return
        }
        
        guard let quantity = statistics.mostRecentQuantity() else {
            print("No mostRecentQuantity for heart rate")
            return
        }

        /*
         HKQuantity representa o valor acompanhado de sua unidade.

         Como queremos BPM, solicitamos o valor em:

         count / minute
        */
        let bpm = quantity.doubleValue(
            for: HKUnit.count().unitDivided(by: .minute())
        )
        
        print("BPM coletado: \(bpm)")

        onHeartRateUpdate?(Int(bpm))
    }
}

// MARK: - HKWorkoutSessionDelegate
extension HealthKitService: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Workout state changed to: \(toState.rawValue)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        self.onError?(error.localizedDescription)
    }
}
