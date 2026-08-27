import SwiftUI

/// Tela que mostra as quatro ações disponíveis e navega para o detalhe escolhido.
struct ActivitiesView: View {

    @Environment(ThemeManager.self) private var theme
    /// A navegação é controlada pela tela que contém o scroll principal.
    @Binding var path: NavigationPath

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Title(text: "TROCAR AÇÃO")
            // Cada caso do enum alimenta o mesmo componente reutilizável.
            ForEach(Activity.allCases) { activity in
                ActivityButton(
                    text: activity.title,
                    subtitle: activity.listSubtitle,
                    icon: activity.iconName(theme: theme.theme, isHighlighted: activity == .breathing),
                    isHighlighted: activity == .breathing
                ) {
                    // Guarda a seleção e apresenta a tela de detalhe correspondente.
                    path.append(activity)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
//        .background(theme)
        // Evita que tamanhos de acessibilidade muito grandes cortem as quatro ações.
        .dynamicTypeSize(.small ... .large)
    }
}

#Preview {
    ActivitiesView(path: .constant(NavigationPath()))
        .environment(ThemeManager())
}
