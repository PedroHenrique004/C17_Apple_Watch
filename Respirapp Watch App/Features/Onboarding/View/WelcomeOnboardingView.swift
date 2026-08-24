//
//  WelcomeOnboardingView.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 21/08/26.
//

import SwiftUI

struct WelcomeOnboardingView: View {
    
    //MARK: Dependencies
    @Environment(ThemeManager.self) private var theme
    
    var viewModel = OnboardingViewModel()
    
    var text: String {
        switch theme.theme {
        case .blue:
            return "blue"
        case .green:
            return "green"
        case .rose:
            return "pink"
        case .purple:
            return "purple"
        }
    }
    
    //Navegação de tela
    let onContinue: (() -> Void)?
    
    
    var body: some View {
        ZStack (alignment: .top){
            theme.ground.opacity(0.0).ignoresSafeArea()
            
            //Estrutura de telas
            VStack (alignment: .leading) {
                
                //Ícone
                Image("icon_heart_ecg_" + text)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
                //Título
                Text("Respiro")
                    .typography(.title2)
                    .padding(.bottom, 4)
                
                //Texto estilizável;
                ZStack {
                    Text("Você segue o seu dia. Eu fico de olho no seu ritmo.")
                        .typography(.footnote, color: .gray)
                    
                    Text("Você segue o seu dia. Eu fico de olho no seu ritmo.")
                        .typography(.footnote, color: theme.accent.opacity(0.5))
                }.padding(.bottom, 16)
                
                //Botão de continuar
                MainButton(
                    text: "Continuar",
                    action: {
                            if let action = onContinue {
                            action()
                        }
                    },
                    icon: nil
                )
                
            }
            .padding(.top, 40)
                .padding(.horizontal, 12)
            .ignoresSafeArea()
            
                
            
                
        }
    }
}

#Preview {
    WelcomeOnboardingView(
        onContinue: nil
    )
        .environment(ThemeManager())
}
