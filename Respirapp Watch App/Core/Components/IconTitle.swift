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
    @Binding var animate: Bool
    
    let text: String
    
    //MARK: View
    var body: some View {
        
        ZStack {
            RoundedRectangle(
                cornerRadius: 999
            )
            .foregroundStyle(theme.surface)
            .frame(width: animate ? 120 : 0, height: 30)
            .opacity(animate ? 1 : 0)
            .animation(.easeInOut(duration: 1)
                .delay(animate ? 0 : 1),
                       value: animate)
            
            //Ícone animado e Texto
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle")
                    .symbolEffect(
                        .drawOn.individually,
                        isActive: !animate
                    )
                    .foregroundStyle(theme.accent)
                    .typography(.footnote)
                
                Text(text)
                    .typography(.footnote)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: animate)
            }
        }
//        Button("Teste") {
//            animate.toggle()
//        
//    }
}
}

struct PreviewWrapper: View {
    @State private var animate = false
    
    var body: some View {
        IconTitle(
            animate: $animate,
            text: "Deu certo!"
        )
        .environment(ThemeManager())
    }
}

#Preview {
    PreviewWrapper()
}
