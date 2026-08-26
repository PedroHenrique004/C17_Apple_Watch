//
//  RespirappApp.swift
//  Respirapp Watch App
//
//  Created by Pedro Santos on 19/08/26.
//

import SwiftUI

@main
struct Respirapp_Watch_AppApp: App {
    //Instância única e global das cores do app.
    @State private var colorScheme = ThemeManager()
    var finishOnboarding = UserPreferencesStore.shared.hasCompletedOnboarding
    
    var body: some Scene {
        WindowGroup {
            if !finishOnboarding {
                OnboardingView()
                    .environment(colorScheme)
            } else {
                AppNavigationView()
                    .environment(colorScheme)
            }
            
        }
    }
}
