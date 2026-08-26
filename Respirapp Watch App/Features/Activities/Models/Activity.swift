import SwiftUI

/// Fonte única dos conteúdos e assets de cada atividade.
/// Centralizar estes dados permite reutilizar as mesmas views sem textos duplicados.
enum Activity: String, CaseIterable, Identifiable, Hashable {
    case breathing, walk, whiteNoise, drinkWater

    /// Identificador usado pelo `ForEach` e pela navegação SwiftUI.
    var id: Self { self }

    /// Nome mostrado na lista de seleção.
    var title: String {
        switch self {
        case .breathing: "Respiração"
        case .walk: "Caminhada"
        case .whiteNoise: "Ruído branco"
        case .drinkWater: "Beber água"
        }
    }

    /// Texto curto que contextualiza a atividade na lista.
    var listSubtitle: String {
        switch self {
        case .breathing: "Melhor agora"
        case .walk: "30 s em pé"
        case .whiteNoise: "Com fones"
        case .drinkWater: "Alguns goles"
        }
    }

    /// Nome usado no card e no cabeçalho do detalhe.
    var detailTitle: String { self == .breathing ? "Respiração guiada" : title }

    /// Tempo ou orientação exibida no card principal.
    var suggestedTime: String {
        switch self {
        case .breathing: "30 segundos, sentado"
        case .walk: "30 segundos em pé"
        case .whiteNoise: "30 segundos, com fones"
        case .drinkWater: "Alguns goles de água"
        }
    }

    /// Mensagem de apoio apresentada durante a execução da atividade.
    var guidance: String {
        switch self {
        // A quebra explícita preserva duas linhas completas na tela pequena do Watch.
        case .breathing: "Solte os ombros.\nNada mais precisa de você agora."
        case .walk: "Levante-se e caminhe por alguns passos."
        case .whiteNoise: "Coloque os fones e ouça por alguns instantes."
        case .drinkWater: "Faça uma pausa e tome alguns goles de água."
        }
    }

    /// Retorna o asset correto conforme o tema e o destaque do item.
    /// Assets inativos permanecem cinza; assets destacados acompanham o tema.
    func iconName(theme: AppTheme, isHighlighted: Bool) -> String {
        guard isHighlighted else { return grayIconName }
        let suffix: String
        switch theme {
        case .purple: suffix = "purple"
        case .blue: suffix = "blue"
        case .rose: suffix = "pink"
        case .green: suffix = "green"
        }
        switch self {
        case .breathing: return "Icon_wind_\(suffix)"
        case .walk: return "Icon_walk_\(suffix)"
        case .whiteNoise: return "icon_sound_\(suffix)"
        case .drinkWater: return theme == .green ? "icon_drop_purple_green" : "icon_drop_\(suffix)"
        }
    }

    /// Variante cinza de cada asset, usada quando a atividade não está destacada.
    private var grayIconName: String {
        switch self {
        case .breathing: "Icon_wind_gray"
        case .walk: "Icon_walk_gray"
        case .whiteNoise: "icon_sound_gray"
        case .drinkWater: "icon_drop_gray"
        }
    }
}
