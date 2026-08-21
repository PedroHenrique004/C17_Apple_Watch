//
//  ActivityButton.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 21/08/26.
//

import SwiftUI

struct ActivityButton: View {
    
    //MARK: Dependencies
    
    @Environment(ThemeManager.self) private var theme
    
    @State var isActive = true
    
    let text: String
    let subtitle: String
    let activeSubtitle = "Melhor Agora"
    let icon: String
    let activeIcon: String
    let action: (() -> Void)?
    
    //MARK: View
    var body: some View {
        Button {
            if let action = action {
                action()
            }
        } label: {
            
            //Ícone e Texo
            HStack (spacing: 16){
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                //Texto
                VStack (alignment: .leading){
                    Text(text)
                        .typography(.callout, color: .white )
                    
                    Text(isActive ? activeSubtitle: subtitle)
                        .typography(.footnote, color: isActive ? theme.accent : .gray)
                        .multilineTextAlignment(.leading)
                }
            }
        }.foregroundStyle(
            isActive ?
            theme.accent.opacity(0.7) :
                theme.accent.opacity(0.4)
        ).overlay(
            RoundedRectangle(
                cornerRadius: 999
            ).stroke(
                theme.accent.opacity(isActive ? 1 : 0),
                lineWidth: 1
                
            )
        )
        
    }
}

#Preview {
    ActivityButton(
        text: "Respiração",
        subtitle: "Respire fundo",
        icon: "Icon_wind_gray",
        activeIcon: "Icon_wind_gray",
        action: {}
    )
        .environment(ThemeManager())
}

