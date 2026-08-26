import SwiftUI

/// Exercício de respiração de 30 segundos.
/// A animação e o cronômetro usam tarefas assíncronas para iniciar imediatamente ao abrir a tela.
struct BreathingExerciseView: View {
    /// Tema global aplicado aos dois círculos e ao fundo.
    @Environment(ThemeManager.self) private var theme
    /// Permite voltar de forma explícita, sem o botão nativo sobrepondo o cabeçalho.
    @Environment(\.dismiss) private var dismiss
    /// Atividade que originou o exercício; mantém o fluxo pronto para o feedback.
    let activity: Activity
    /// Fecha todo o fluxo após o feedback e leva a pessoa de volta à lista.
    let onFinish: () -> Void
    /// Alterna entre as fases de inspirar e expirar.
    @State private var isInhaling = true
    /// Contador visível em segundos.
    @State private var remainingSeconds = 30
    /// Controla a navegação automática ao feedback no fim do exercício.
    @State private var isFinished = false

    var body: some View {
        VStack(spacing: 8) {
            exerciseHeader
            breathingOrb

            Text(isInhaling ? "Inspire" : "Expire")
                .id(isInhaling)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .transaction { $0.animation = nil }

    
            Text(activity.guidance)
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.top, 4)
        .background(theme.ground)
        .navigationBarBackButtonHidden()
        .dynamicTypeSize(.small ... .large)
        .task { await runBreathingCycle() }
        .task { await runCountdown() }
        .navigationDestination(isPresented: $isFinished) {
            FeedbackHandoffView(activity: activity, onClose: onFinish)
        }
    }

    /// Cabeçalho próprio, que mantém o retorno acessível sem cobrir o título.
    private var exerciseHeader: some View {
        HStack(spacing: 8) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 12, weight: .bold))
                    .frame(width: 26, height: 26)
                    .background(theme.surface.opacity(0.7))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Text(activity.detailTitle)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.65))
                .lineLimit(1)
                .minimumScaleFactor(0.65)
            Spacer(minLength: 0)
            Text("\(remainingSeconds) s")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.65))
        }
    }

    /// Desenha os dois círculos como um único grupo para ambos subirem e descerem juntos.
    private var breathingOrb: some View {
        ZStack {
            Circle()
                .stroke(theme.accent, lineWidth: 4)
                .frame(width: 96, height: 96)
            Circle()
                .fill(theme.accent.opacity(0.16))
                .frame(width: 62, height: 62)
        }
        .scaleEffect(isInhaling ? 1 : 0.8)
        .offset(y: isInhaling ? -8 : 8)
        .animation(.easeInOut(duration: 3), value: isInhaling)
    }

    /// Alterna a fase a cada três segundos; a tarefa começa assim que a tela aparece.
    @MainActor private func runBreathingCycle() async {
        while !Task.isCancelled && remainingSeconds > 0 {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            guard !Task.isCancelled, remainingSeconds > 0 else { return }
            isInhaling.toggle()
        }
    }

    /// Atualiza o contador e ativa a navegação para o feedback ao chegar a zero.
    @MainActor private func runCountdown() async {
        while !Task.isCancelled && remainingSeconds > 0 {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            guard !Task.isCancelled, remainingSeconds > 0 else { return }
            remainingSeconds -= 1
        }
        if !Task.isCancelled { isFinished = true }
    }
}

//tela temporaria de feedback
private struct FeedbackHandoffView: View {
    /// Tema global para manter o feedback consistente com a atividade anterior.
    @Environment(ThemeManager.self) private var theme
    /// Atividade concluída, usada para personalizar a mensagem.
    let activity: Activity
    /// Ação fornecida pela lista para limpar a navegação ao fechar o feedback.
    let onClose: () -> Void

    var body: some View {
        VStack {
            Spacer(minLength: 0)
            feedbackCard
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .background(theme.ground)
        .navigationBarBackButtonHidden()
    }

    /// Card provisório de conclusão, preparado para ser substituído pela tela final de feedback.
    private var feedbackCard: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .frame(width: 28, height: 28)
                        .background(theme.ground.opacity(0.55))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 42))
                .foregroundStyle(theme.accent)
            // A quebra explícita impede que o título seja truncado na largura do Watch.
            Text("Exercício\nconcluído")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(theme.accent.opacity(0.45), lineWidth: 1)
        }
    }
}

#Preview {
    NavigationStack { BreathingExerciseView(activity: .breathing, onFinish: {}) }.environment(ThemeManager())
}
