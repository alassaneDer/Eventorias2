//
//  IconicButton.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//
import SwiftUI

struct IconicButton: View {
    @Environment(\.self) private var env

    var backgroundColor: Color = Color(hex: "#D0021B")
    var iconColor: Color = .white
    var action: () -> Void = {}
    var imageSystemName: String = "plus"
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }, label: {
            Image(systemName: imageSystemName)
                .foregroundStyle(iconColor)
                .fontWeight(.bold)
                .padding()
                .frame(width: 52)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID())
        })
        .hoverEffect(.lift)
    }
}

#Preview {
    IconicButton()
}
/// Reutilisable sur TROIS ecrans : list et creation
