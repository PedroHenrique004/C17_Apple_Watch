//
//  DSColors.swift
//  UseCasesAppleWatch
//
//  Created by Micael Martins de Moura on 19/08/26.
//

import SwiftUI
import Foundation


//Design System com as cores que serão utilizadas no projeto.

public extension Color {
        
    //MARK:  Conjunto de cor 1 - ROXO
    static let Pg = Color("161826")
    static let Ps = Color("232532")
    static let Pa = Color("9184d9")
    
    //MARK:  Conjunto de cor 2 - Azul
    static let Bg = Color("161d27")
    static let Bs = Color("242a33")
    static let Ba = Color("93afd7")
    
    //MARK:  Conjunto de cor 3 - Vermelho Rosado
    static let Rg = Color("271619")
    static let Rs = Color("332426")
    static let Ra = Color("d7939e")
    
    //MARK:  Conjunto de cor 4 - Verde
    static let Gg = Color("16271f")
    static let Gs = Color("24332b")
    static let Ga = Color("93d7b5")
    
}

    //MARK: - Enum das cores
enum AppTheme {
    case purple
    case blue
    case rose
    case green
}


///Essa classe deve ser utilizada como uma única instância global, definida no arquivo raíz do app.
///
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
///
///Isso que permite utilizar:
///
///`themeManager.ground`
///
///`themeManager.surface`
///
///`themeManager.accent`
///
///`themeManager.theme = .blue`
@Observable
class ThemeManager {
    var theme: AppTheme = .purple //Por Default será roxo.
    
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
