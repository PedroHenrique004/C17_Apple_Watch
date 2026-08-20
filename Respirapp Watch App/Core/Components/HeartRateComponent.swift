//
//  HeartRateComponent.swift
//  Respirapp
//
//  Created by Ana Luisa Teixeira Coleone Reis on 20/08/26.
//

import SwiftUI

struct HeartRateComponent: View {
    @State var bpm: Int

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 4) {
            Text("\(bpm)")
                .font(.system(size: 64, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)

            Text("bpm")
                .typography(.body, color: .gray)
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.07, green: 0.08, blue: 0.13)
            .ignoresSafeArea()
        HeartRateComponent(bpm: 68)
    }
}
