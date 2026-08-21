//
//  OnboardingView.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 21/08/26.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        //Bem vindo e permissões
        WelcomeOnboardingView()
        //Teste de haptics
        //Tela de início do app
    }
}

#Preview {
    OnboardingView()
        .environment(ThemeManager())
}
