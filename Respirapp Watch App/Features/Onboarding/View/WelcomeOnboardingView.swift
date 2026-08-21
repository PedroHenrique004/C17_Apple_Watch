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
    
    var body: some View {
        ZStack (alignment: .top){
            theme.ground.opacity(0.7).ignoresSafeArea()
            
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
                
                //Texto estilizáve;
                ZStack {
                    Text("Quando seu ritmo subir, eu aviso e já digo o que fazer.")
                        .typography(.footnote, color: .gray)
                    
                    Text("Quando seu ritmo subir, eu aviso e já digo o que fazer.")
                        .typography(.footnote, color: theme.accent.opacity(0.5))
                }.padding(.bottom, 16)
                
                //Botão de continuar
                MainButton(
                    text: "Começar",
                    action: {
                        
                    },
                    icon: nil
                )
                
            }.padding(.top, 48)
                .padding(.horizontal, 8)
            .ignoresSafeArea()
                
            
                
        }
    }
}

#Preview {
    WelcomeOnboardingView()
        .environment(ThemeManager())
}
