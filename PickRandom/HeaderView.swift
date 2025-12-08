//
//  HeaderView.swift
//  PickRandom
//
//  Created by Андрей on 08.12.2025.
//

import SwiftUI

struct HeaderView: View {
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "figure.socialdance")
                .foregroundStyle(.tint)
                .symbolRenderingMode(.hierarchical)
            Text("Pick-Random-Person")
        }
        .font(.system(size: 15))
        .bold()
    }
}
