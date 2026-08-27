import SwiftUI

/// Tela que mostra as quatro ações disponíveis e navega para o detalhe escolhido.
struct ActivitiesView: View {

    @Environment(ThemeManager.self) private var theme
    /// Pilha de navegação: recebe a atividade selecionada e abre seu detalhe.
    @Binding var path: NavigationPath

    var body: some View {
        // A navegação é baseada no modelo `Activity`, mantendo a seleção tipada.

                VStack(alignment: .leading, spacing: 10) {
//                    Title(text: "TROCAR AÇÃO")
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
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
            // Evita que tamanhos de acessibilidade muito grandes cortem as quatro ações.
            .dynamicTypeSize(.small ... .large)
            .navigationDestination(for: Activity.self) { activity in
                // Destino único que se adapta ao conteúdo da atividade recebida.
                ActivityDetailView(activity: activity) {
                    // O feedback encerra o fluxo e volta à lista, nunca ao exercício concluído.
                    closeCompletedExercise()
                }
            }
        }.navigationTitle("Atividades")
    }

    /// Fecha o fluxo concluído de uma vez, sem animar as telas intermediárias ao voltar.
    private func closeCompletedExercise() {
        var transaction = Transaction()
        transaction.disablesAnimations = true

        withTransaction(transaction) {
            path = NavigationPath()
        }
    }
}

#Preview {
    ActivitiesView(
        path: .constant(NavigationPath())
    ).environment(ThemeManager())
}
