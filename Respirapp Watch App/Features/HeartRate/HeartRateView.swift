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

    @State private var viewModel = HeartRateViewModel()
    @State private var animateHeart = false
    
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .symbolEffect(
                    .bounce.down.wholeSymbol,
                    value: animateHeart
                )
                .onChange(of: viewModel.bpm) {
                    animateHeart.toggle()
                }
                .font(.system(size: 64))
                .foregroundStyle(.red)
                .padding(.bottom, 12)

            HeartRateComponent(bpm: viewModel.bpm)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 10))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
//        .task {
//            await viewModel.start()
//        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

#Preview {
    HeartRateView()
        .environment(ThemeManager())
}
