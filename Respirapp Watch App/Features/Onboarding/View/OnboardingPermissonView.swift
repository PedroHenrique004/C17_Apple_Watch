//
//  OnboardingPermissonView.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 24/08/26.
//

import SwiftUI

struct OnboardingPermissonView: View {
    
    //MARK: Dependencies
    @Environment(ThemeManager.self) private var theme
    
    @State var animate = false
    
    var viewModel = OnboardingViewModel()
    
    //Navegação de tela
    let onContinue: (() -> Void)?
    
    //Animação
    @State var opacity = false
    
    //MARK: View
    var body: some View {
        ZStack {
            theme.ground.opacity(0.0)
                .ignoresSafeArea()
            
            //Estrutura da tela
            ScrollView {
                VStack (alignment: .leading) {
                    
                    //Ícone
                    Image(systemName: "lock.applewatch")
                        .foregroundStyle(theme.accent)
                        .typography(.title)
                        .padding(.bottom, 4)
                    //                        .symbolEffect(.drawOn.individually, options: .nonRepeating,
                    //                        isActive: animate)
                    
                    //Título principal
                    Text("Vamos preparar tudo")
                        .typography(.title3)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .padding(.bottom, 4)
                    
                    //Subtítulo
                    ZStack {
                        
                        Text("Precisamos de algumas permissões para acompanhar seu ritmo.")
                            .typography(.footnote, color: .gray)
                        
                        Text("Precisamos de algumas permissões para acompanhar seu ritmo.")
                            .typography(.footnote, color: theme.accent.opacity(0.5))
                        
                    }.padding(.bottom, 8)
                    
                    //Botão
                    MainButton(
                        text: "Permitir acesso",
                        action: {
                            Task {
                                await viewModel.requestAuthorization()
                            }
                            
                            if viewModel.isPermissionGranted {
                                
                                if let action = onContinue {
                                    action()
                                }
                            }
                        },
                        icon: nil
                    )
                    
                }.padding(.horizontal, 12)
                    .ignoresSafeArea()
                    .opacity(opacity ? 1 : 0).animation(.easeInOut(duration: 2), value: opacity)
            }
                
            }.onAppear {
            animate = true
            opacity = true
        }
    }
}

#Preview {
    OnboardingPermissonView(
        onContinue: nil
    )
        .environment(ThemeManager())
}
