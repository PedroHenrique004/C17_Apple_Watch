//
//  IconTitle.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 20/08/26.
//

import SwiftUI

struct IconTitle: View {
    
    //MARK: Dependencies
    @Environment(ThemeManager.self) private var theme
    @State private var animate = false
    let text: String
    
    
    //MARK: View
    var body: some View {
        
        //Ícone animado e Texto
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle")
                .symbolEffect(
                    .drawOn.individually,
                    isActive: animate
                )
                .foregroundStyle(theme.accent)
                .typography(.footnote)
            
            Text(text)
                .typography(.footnote)
                .opacity(animate ? 0 : 1)
                .animation(.easeInOut(duration: 0.5), value: animate)
            
            Button("Teste") {
                animate.toggle()
            }
        }.onAppear {
            animate = true
        }
        
    }
}

#Preview {
    IconTitle(
        text: "Deu certo!"
    ).environment(ThemeManager())
}
