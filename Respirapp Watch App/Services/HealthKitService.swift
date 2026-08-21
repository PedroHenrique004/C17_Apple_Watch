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
    func startHeartRateMonitoring(onUpdate: @escaping (Int) -> Void)
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

    func startHeartRateMonitoring(onUpdate: @escaping (Int) -> Void) {
        self.onHeartRateUpdate = onUpdate

        do {
            let session = try HKWorkoutSession(
                healthStore: healthStore,
                configuration: workoutConfiguration
            )

            let builder = session.associatedWorkoutBuilder()

            builder.delegate = self
            builder.dataSource = HKLiveWorkoutDataSource(
                healthStore: healthStore,
                workoutConfiguration: workoutConfiguration
            )

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
        guard
            let heartRateType,
            let statistics = workoutBuilder.statistics(for: heartRateType),
            let quantity = statistics.mostRecentQuantity()
        else {
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

        onHeartRateUpdate?(Int(bpm))
    }
}
