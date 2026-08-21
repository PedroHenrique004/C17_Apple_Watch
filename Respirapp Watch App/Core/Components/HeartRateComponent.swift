//
//  HeartRateComponent.swift
//  Respirapp
//
//  Created by Ana Luisa Teixeira Coleone Reis on 20/08/26.
//

import SwiftUI

struct HeartRateComponent: View {
    @Environment(ThemeManager.self) private var theme
    
    @State var bpm: Int

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 4) {
            ZStack {
                
                //Base branca
                Text("\(bpm)")
                    .font(.system(size: 64, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                
                //Cor do app
                Text("\(bpm)")
                    .font(.system(size: 64, weight: .semibold, design: .rounded))
                    .foregroundStyle(theme.accent.opacity(0.5))
                
            }

            Text("bpm")
                .typography(.body, color: theme.accent.opacity(0.5))
        }
    }
}

#Preview {
    ZStack {
        Color(ThemeManager().ground)
            .ignoresSafeArea()
        HeartRateComponent(bpm: 68)
            .environment(ThemeManager())
    }
}
