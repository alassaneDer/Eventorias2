//
//  SwiftUIView.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import SwiftUI
struct BottomAuthPrompt: View {
    
    let text: LocalizedStringKey
    let actionText: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(text)
                .font(.custom("Inter-Regular", size: 14))

            Text(actionText)
                .font(.custom("Inter-Regular", size: 14))
                .fontWeight(.semibold)
                .foregroundStyle(Color(hex: "#D0021B"))
                .underline()
                .onTapGesture(perform: {
                    action()
                })
        }
    }
}

#Preview {
    BottomAuthPrompt(text: "Pas de compte ?", actionText: "S'inscrire maintenant", action: {})
}
