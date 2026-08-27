import SwiftUI

struct SettingsView: View {

    @ObservedObject private var preferences = UserPreferencesStore.shared
    @Environment(ThemeManager.self) private var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
//                Title(text: "AJUSTES")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.bottom, 4)

                SettingsToggleCard(
                    title: "Notificações",
                    subtitle: preferences.isNotificationsEnabled ? "Ativadas" : "Desativadas",
                    isOn: $preferences.isNotificationsEnabled,
                    theme: theme
                )
                
                SettingsToggleCard(
                    title: "Vibração",
                    subtitle: preferences.isHapticsEnabled ? "Ativada" : "Desativada",
                    isOn: $preferences.isHapticsEnabled,
                    theme: theme
                )
                
                Text("Receba alertas quando seus batimentos indicarem possíveis sinais de estresse.")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(theme.accent.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
                
                Title(text: "PERSONALIZAR")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 4)
                
                SettingsColor(theme: theme)
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .navigationTitle("Ajustes")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    SettingsView()
        .environment(ThemeManager())
}
