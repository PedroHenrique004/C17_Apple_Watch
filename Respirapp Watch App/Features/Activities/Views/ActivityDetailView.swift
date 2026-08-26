import SwiftUI

/// Card de orientação da atividade escolhida.
/// Somente o card de respiração é navegável para o exercício guiado.
struct ActivityDetailView: View {

    @Environment(ThemeManager.self) private var theme
    /// Fecha esta tela e retorna à lista de atividades.
    @Environment(\.dismiss) private var dismiss
    /// Conteúdo que será exibido no card.
    let activity: Activity
    /// Encerra o fluxo concluído e retorna à lista de exercícios.
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // Cabeçalho compacto para preservar área para o card principal.
            HStack {
                Text(activity.detailTitle)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.65))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer()
                Text(activity == .breathing ? "30 s" : "")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.65))
            }

            // O card recebe mais altura que o botão secundário para acomodar o conteúdo.
            activityCard
            changeActivityButton
        }
        .padding(.horizontal, 10)
        .background(theme.ground)
        .navigationBarBackButtonHidden()
        .dynamicTypeSize(.small ... .large)
    }

    /// Torna o card um link apenas para a respiração; outras ações são informativas.
    @ViewBuilder private var activityCard: some View {
        if activity == .breathing {
            NavigationLink { BreathingExerciseView(activity: activity, onFinish: onFinish) } label: { cardContent }
                .buttonStyle(.plain)
        } else {
            cardContent
        }
    }

    /// Layout visual do card, compartilhado pelos estados navegável e informativo.
    private var cardContent: some View {
        HStack(spacing: 10) {
            Image(activity.iconName(theme: theme.theme, isHighlighted: true))
                .resizable().scaledToFit().frame(width: 28, height: 28)
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.detailTitle)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                Text(activity.suggestedTime)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.65))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 100)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay { RoundedRectangle(cornerRadius: 22).stroke(theme.accent.opacity(0.55), lineWidth: 1) }
    }

    /// Ação secundária compacta para voltar e escolher outra atividade.
    private var changeActivityButton: some View {
        Button(action: { dismiss() }) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 12, weight: .medium))
                Text("Trocar atividade")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
            }
            .foregroundStyle(theme.accent)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(theme.surface.opacity(0.45))
            .clipShape(Capsule())
            .overlay { Capsule().stroke(theme.accent.opacity(0.55), lineWidth: 1) }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack { ActivityDetailView(activity: .breathing, onFinish: {}) }.environment(ThemeManager())
}
