//
//  AppNavigationView.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 25/08/26.
//

import SwiftUI

struct AppNavigationView: View {
    @Environment(ThemeManager.self) private var theme

    var body: some View {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 96) {
                    
                    //Tela dos batimentos cardíacos
                    HeartRateView()
                    
                    //TODO: Tela das atividades
                    
                    //Tela das configurações
                    SettingsView()

                    
                }
            }
            .background(theme.ground.opacity(0.7))
        }
    }
//}

#Preview {
    AppNavigationView()
        .environment(ThemeManager())
}
