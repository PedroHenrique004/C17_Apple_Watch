//
//  AppNavigationView.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 25/08/26.
//

import SwiftUI

struct AppNavigationView: View {
    @Environment(ThemeManager.self) private var theme
    @State private var activityPath = NavigationPath()

    private enum Section {
        case activities
        case home
        case settings
    }

    var body: some View {
        NavigationStack(path: $activityPath) {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 96) {
                        // A lista é rolada pelo ScrollView principal, sem scroll aninhado.
                        ActivitiesView(path: $activityPath)
                            .id(Section.activities)

                        // A tela principal fica entre atividades e ajustes.
                        HeartRateView()
                            .id(Section.home)

                        // Ao rolar para baixo, mostra os ajustes.
                        SettingsView()
                            .id(Section.settings)
                    }
                }
                .onAppear {
                    // Abre no centro; a lista fica ao rolar para cima.
                    proxy.scrollTo(Section.home, anchor: .center)
                }
            }
            .navigationDestination(for: Activity.self) { activity in
                ActivityDetailView(activity: activity) {
                    closeCompletedExercise()
                }
            }
        }
        .background(theme.ground.opacity(0.7))
    }

    private func closeCompletedExercise() {
        var transaction = Transaction()
        transaction.disablesAnimations = true

        withTransaction(transaction) {
            activityPath = NavigationPath()
        }
    }
}

#Preview {
    AppNavigationView()
        .environment(ThemeManager())
}
