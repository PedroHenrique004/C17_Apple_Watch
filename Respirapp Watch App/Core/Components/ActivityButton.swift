import SwiftUI

/// Botão reutilizável usado por cada item da lista de atividades.
/// O conteúdo e o estado visual são recebidos da tela que o utiliza.
struct ActivityButton: View {
    /// Tema global; fornece as cores que acompanham a escolha do usuário.
    @Environment(ThemeManager.self) private var theme

    /// Título principal da atividade.
    let text: String
    /// Instrução curta exibida sob o título.
    let subtitle: String
    /// Nome do asset do ícone já adequado ao tema ou ao estado inativo.
    let icon: String
    /// Define se o item é a recomendação destacada da lista.
    let isHighlighted: Bool
    /// Ação executada quando a pessoa escolhe a atividade.
    let action: (() -> Void)?

    var body: some View {
        // A ação é opcional para permitir uso em previews e estados estáticos.
        Button(action: { action?() }) {
            HStack(spacing: 9) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .opacity(isHighlighted ? 1 : 0.6)

                VStack(alignment: .leading, spacing: 2) {
                    Text(text)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text(subtitle)
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundStyle(isHighlighted ? theme.accent : .gray.opacity(0.7))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .frame(maxWidth: .infinity, alignment: .leading)
            // Mantém cada linha compacta e confortável no Apple Watch.
            .frame(minHeight: 44)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            // Apenas o item recomendado ganha borda na cor do tema.
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(theme.accent.opacity(isHighlighted ? 1 : 0), lineWidth: 1)
            }
        }
        // Evita que o estilo padrão do watchOS aumente a altura do componente.
        .buttonStyle(.plain)
    }
}

#Preview {
    ActivityButton(
        text: "Respiração",
        subtitle: "Melhor agora",
        icon: "Icon_wind_green",
        isHighlighted: true,
        action: {}
    )
    .environment(ThemeManager())
}
