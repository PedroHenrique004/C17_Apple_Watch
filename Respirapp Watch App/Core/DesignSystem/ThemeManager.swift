//
//  ThemeManager.swift
//  Respirapp Watch App
//
//  Created by Pedro Santos on 27/08/26.
//

import SwiftUI
import Foundation
import Observation
import WidgetKit

///Essa classe deve ser utilizada como uma única instância global, definida no arquivo raíz do app.
///
///Deve ser instanciada da seguinte maneira:
///
///`@State private var colorScheme = ThemeManager()`
///
///No começo da hierarquia das views colocamos: `.environment(colorScheme)`
///
///Depois, em todas as views que fizerem o uso das cores precisamos colocar:
///
///`@Environment(ThemeManager.self) private var theme`
@Observable
class ThemeManager {
    var theme: AppTheme = UserPreferencesStore.shared.actualColor { //Por Default será roxo.
        didSet {
            // Salva a preferência do app
            UserPreferencesStore.shared.actualColor = theme
            
            // Salva no App Group para o Widget conseguir ler
            UserDefaults(suiteName: "group.dev.pedrosantos.respirapp-c17")?
                .set(theme.rawValue, forKey: "widgetTheme")
            
            // Avisa o sistema para redesenhar o widget imediatamente
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    //Cores do fundo
    var ground: Color {
        switch theme {
        case .purple: return .Pg
        case .blue: return .Bg
        case .rose: return .Rg
        case .green: return .Gg
        }
    }
    
    //Cores da superfície
    var surface: Color {
        switch theme {
        case .purple: return .Ps
        case .blue: return .Bs
        case .rose: return .Rs
        case .green: return .Gs
        }
    }
    
    //Cores principais
    var accent: Color {
        switch theme {
        case .purple: return .Pa
        case .blue: return .Ba
        case .rose: return .Ra
        case .green: return .Ga
        }
    }
}
