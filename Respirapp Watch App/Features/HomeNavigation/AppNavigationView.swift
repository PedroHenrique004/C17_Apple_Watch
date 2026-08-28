//
//  AppNavigationView.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 25/08/26.
//

import SwiftUI

struct AppNavigationView: View {
    @Environment(ThemeManager.self) private var theme

    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 96) {
                    
                    //Tela dos batimentos cardíacos
                    HeartRateView()
                    
                    //Atalho para a sessão de respiração guiada (WorkoutKit)
                    NavigationLink {
                        BreathingWorkoutView()
                    } label: {
                        Text("Sessão de Respiração")
                    }
                    
                    //Tela das atividades
                    ActivitiesView(path: $path)
                    
                    //Tela das configurações
                    SettingsView()
                    
                    
                }
            }
        }
            .background(theme.ground.opacity(0.7))
            .navigationDestination(for: Activity.self) { activity in

                        ActivityDetailView(activity: activity) {

                            path = NavigationPath()

                        }

                    }
        }
    }

#Preview {
    AppNavigationView()
        .environment(ThemeManager())
}
