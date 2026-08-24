//
//  OnboardingEnd.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 24/08/26.
//

import SwiftUI

struct OnboardingEnd: View {
    
    //MARK: Dependencies
    @Environment(ThemeManager.self) private var theme
    
    @State var animate = false
    
    private var viewModel = HeartRateViewModel()
    
    
    //MARK: View
    var body: some View {
        ZStack (alignment: .topLeading){
            theme.ground.opacity(0.0)
                .ignoresSafeArea()
            
            VStack (alignment: .leading){
                
                //Título da tela
                IconTitle(
                    animate: $animate, text: "Tudo Pronto!")
                .padding(.bottom, 16)
                
                //Batimentos registrados
                HeartRateComponent(bpm: viewModel.bpm)
                
                //Frase ligada aos batimentos
                //TODO: Dentro da HeartRateViewModel criar uma lista com diferentes palavras para diferentes intervalos de batimentos
                Text("Tudo calmo por aqui.") //Placeholder
                    .typography( .footnote)
                    .padding(.bottom, 4)
                
                //Linha estilizante
                Rectangle()
                    .frame(width: 80, height: 1)
                    .foregroundStyle(theme.accent)
                
                Spacer()
                
                Text("Acompanhando seu ritmo. \nVou avisar se ele subir")
                    .font(.system(size: 10))
                    .foregroundStyle(theme.accent.opacity(0.3))
                
            }.padding(24)

            
            .onAppear {
                animate = true
            }.ignoresSafeArea()
            
        }
    }
}

#Preview {
    OnboardingEnd()
        .environment(ThemeManager())
}
