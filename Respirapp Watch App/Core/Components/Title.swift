//
//  Title.swift
//  Respirapp Watch App
//
//  Created by Micael Martins de Moura on 21/08/26.
//

import SwiftUI

struct Title: View {
    
    //MARK: - Depencencies
    @Environment(ThemeManager.self) private var theme
    
    let text: String
    
    //MARK: View
    var body: some View {
        Text(text)
            .typography(.subheadline, color: theme.accent.opacity(0.5))
    }
}

#Preview {
    Title(
        text: "Respiro"
    ).environment(ThemeManager())
}
