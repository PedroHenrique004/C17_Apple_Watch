//
//  OnboardingHaptics.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 24/08/26.
//

import SwiftUI

struct OnboardingHaptics: View {
    
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
        ZStack (alignment: .top) {
            theme.ground.opacity(0.0)
                .ignoresSafeArea()
            
            //Estrutura da tela
            ScrollView {
                VStack (alignment: .leading) {
                    
                    //Ícone
                    Image(systemName: "applewatch.radiowaves.left.and.right")
                        .foregroundStyle(theme.accent)
                        .typography(.title)
                        .padding(.bottom, 4)
                        .symbolEffect(.bounce,
                                      options: .repeat(2),
                                      value: animate)
                    
                    //Título principal
                    Text("Dois toques leves no pulso")
                        .typography(.title3)
                        .multilineTextAlignment(.leading)
                    
                        .padding(.bottom, 4)
                    
                    //Subtítulo
                    ZStack {
                        
                        Text("Te avisamos sem som, sem tela acesa.")
                            .typography(.footnote, color: .gray)
                        
                        Text("Te avisamos sem som, sem tela acesa.")
                            .typography(.footnote, color: theme.accent.opacity(0.5))
                        
                    }.padding(.bottom, 8)
                    
                    //Botão
                    MainButton(
                        text: "Continuar",
                        action: {
                            
                            //TODO: haptics
                            
                            //Isso deve acontecer depois dos haptics
                            if let action = onContinue {
                                action()
                            }
                        },
                        icon: nil
                    )
                    
                }.padding(.horizontal, 12)
                    .ignoresSafeArea()
                    .opacity(opacity ? 1 : 0).animation(.easeInOut(duration: 2), value: opacity)
            }
            
        }.onAppear{
            opacity = true
            Task{
                while !Task.isCancelled {
                    animate.toggle()
                    
                    try? await Task.sleep(for: .seconds(3))
                }
            }
        }
    }
}

#Preview {
    OnboardingHaptics(
        onContinue: nil
    )
        .environment(ThemeManager())
}
