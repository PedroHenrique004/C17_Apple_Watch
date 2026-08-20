//
//  mainButton.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 20/08/26.
//

import SwiftUI

struct MainButton: View {
    
    //MARK: - Dependencies
    //Requisito de cor obrigatório
    @Environment(ThemeManager.self) private var theme
    
    let text: String
    let action: (() -> Void)?
    let icon: String?
    
    //MARK: - View
    var body: some View {
        Button {
            if let action = action {
                action()
            }
        } label: {
            //
            HStack (spacing: 8) {
                if let image = icon {
                    Image(systemName: image)
                }
                
                Text(text)
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .foregroundStyle(theme.accent.opacity(0.7))
            .overlay(
                RoundedRectangle(
                    cornerRadius: 99
                ).stroke(
                    theme.accent,
                    lineWidth: 1
                    )
            )
    }
}

#Preview {
    MainButton(
        text: "Começar",
        action: nil,
        icon: nil,
    ).environment(ThemeManager())
}
