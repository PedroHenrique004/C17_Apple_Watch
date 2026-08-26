//
//  SettingsColor.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 26/08/26.
//

import SwiftUI

struct SettingsColor: View {
    
    //MARK: Dependencies
    let theme: ThemeManager
    
    //Nomes das cores
    var colorName: String {
        switch theme.theme {
        case .blue:
            return "Azul"
        case .green:
            return "Verde"
        case .purple:
            return "Roxo"
        case .rose:
            return "Rose"
        }
    }
    
    var body: some View {
        VStack (alignment: .leading){
            HStack(spacing: 4) {
                Text("Cor padrão:")
                    .typography(Font.Respirapp.bodyMedium, color: .white)
                
                Text(colorName)
                    .typography(Font.Respirapp.title3,
                                color: theme.accent)
            }
            
            HStack {
                ForEach (AppTheme.allCases, id: \.self) { color in
                    
                    Button {
                        theme.theme = color
                        UserPreferencesStore.shared.actualColor = color
                        
                    } label: {
                        Circle()
                            .foregroundStyle(
                                theme.theme == color ? color.accent : color.accent.opacity(0.5))
                            .frame(width: 24)
                            .overlay(
                                Circle()
                                    .strokeBorder(.white.opacity(0.6), lineWidth: 3)
                                    .opacity(theme.theme == color ? 1 : 0)
                            )
                    }.buttonStyle(.plain)
                }
            }
            

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(theme.surface)
        .cornerRadius(16)
    }
}

#Preview {
    SettingsColor(
        theme: ThemeManager()
    )
}
