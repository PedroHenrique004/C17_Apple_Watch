//
//  HeartRateView.swift
//  Respirapp Watch App
//
//  Camada de apresentação: apenas UI. Toda a lógica de HealthKit,
//  autorização e a regra de "batimento alto" vive no HeartRateViewModel
//  e nas camadas de Domínio/Dados por trás dele.
//

import SwiftUI

struct HeartRateView: View {
    
    //MARK: Dependencies
    @Environment(ThemeManager.self) private var theme
    
    @State private var viewModel = HeartRateViewModel()
    @State private var animateHeart = false
    @State var animate = false
    
    //MARK: View
    var body: some View {
        
        ZStack {
            ZStack (alignment: .topLeading){
                theme.ground.opacity(0.0)
                    .ignoresSafeArea()
                
                VStack (alignment: .leading){
                    
                    if !UserPreferencesStore.shared.hasCompletedOnboarding {
                        
                        //Título da tela
                        IconTitle(
                            animate: $animate, text: "Tudo Pronto!")
                        .task {
                            try? await Task.sleep(for: .seconds(4))
                            animate = false
                        }
                    }

                    
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
                    
                    
                }.padding(.horizontal, 24)
                    .ignoresSafeArea()
                    .onAppear {
                        animate = true
                        Task {
                            try? await Task.sleep(for: .seconds(10))
                            //Salva que o Onboarding foi concluido
                            UserPreferencesStore.shared.hasCompletedOnboarding = true
                        }
                    }
                
                
                    .task {
                        await viewModel.start()
                    }
                    .onDisappear {
                        viewModel.stop()
                    }
            }
        }
    }
}

#Preview {
    HeartRateView()
        .environment(ThemeManager())
}
