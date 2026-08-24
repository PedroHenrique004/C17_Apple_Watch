//
//  SettingsToogle.swift
//  Respirapp Watch App
//
//  Created by Pedro Santos on 24/08/26.
//

import SwiftUI

struct SettingsToggleCard: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let theme: ThemeManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .typography(Font.Respirapp.bodyMedium, color: .white)
                
                Text(subtitle)
                    .typography(Font.Respirapp.footnote, color: isOn ? theme.accent : .gray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(theme.accent)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(theme.surface)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isOn ? theme.accent.opacity(0.5) : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    SettingsToggleCard(
        title: "Notificações",
        subtitle: "Ativadas",
        isOn: .constant(false),
        theme: ThemeManager()
    )
}
