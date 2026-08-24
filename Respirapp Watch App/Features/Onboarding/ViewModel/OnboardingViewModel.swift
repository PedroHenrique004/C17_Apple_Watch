//
//  OnboardingViewModel.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 21/08/26.
//

import Foundation
import Observation

@Observable
final class OnboardingViewModel {
    
    private let healthKitService: HealthKitServiceProtocol
    private let notificationService: NotificationServiceProtocol
    
    var isPermissionGranted = false
    
    init(healthKitService: HealthKitServiceProtocol = HealthKitService(), notificationService: NotificationServiceProtocol
    = NotificationService()) {
        self.healthKitService = healthKitService
        self.notificationService = notificationService
    }
    
    func requestAuthorization() async {
        do {
            try await healthKitService.requestAuthorization()
            isPermissionGranted = true
        } catch {
            isPermissionGranted = false
            print(error)
        }
        
        await notificationService.requestAuthorization()
        
        
    }

}
