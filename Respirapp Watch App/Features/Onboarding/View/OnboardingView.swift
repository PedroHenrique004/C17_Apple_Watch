//
//  OnboardingView.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 21/08/26.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(ThemeManager.self) private var theme
    
    enum page {
        case welcome
        case permission
        case haptics
        case end
    }

    @State private var currentPage: page = .welcome
    
    var body: some View {
        ZStack {
            
            theme.ground.opacity(0.7).ignoresSafeArea()
            
            Group {
                switch currentPage {
                case .welcome:
                    WelcomeOnboardingView(
                        onContinue: {
                            currentPage = .permission
                        }
                    ).transition(.opacity)
                    
                case .permission:
                    OnboardingPermissonView(
                        onContinue: {
                            currentPage = .haptics
                        }
                    )
                case .haptics:
                    OnboardingHaptics(
                        onContinue: {
                            currentPage = .end
                        }
                    )
                case .end:
                    AppNavigationView()
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environment(ThemeManager())
}
