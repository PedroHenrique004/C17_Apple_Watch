//
//  OnboardingHaptics.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 24/08/26.
//

import SwiftUI
import WatchKit

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
                            if let action = onContinue {
                                
                                //Navega para a próxima tela.
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
        }.task{
            while !Task.isCancelled {
                
                //Animação começa
                animate.toggle()
                
                //Haptic1
                WKInterfaceDevice.current().play(.click)
                try? await Task.sleep(for: .seconds(0.5))
                
                //Haptic2
                WKInterfaceDevice.current().play(.click)
                
                //Animação espera para repetir
                try? await Task.sleep(for: .seconds(3))
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
