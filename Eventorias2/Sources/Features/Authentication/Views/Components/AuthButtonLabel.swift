//
//  AuthButtonLabel.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import SwiftUI

struct AuthButtonLabel: View {
    
    var titleLabel: LocalizedStringKey = "se connecter"
    var backgroundColor: Color = Color(hex: "#D0021B")
    @State var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(titleLabel)
                .font(.custom("Inter-Regular", size: 20))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .fill(backgroundColor)
                )
        })
    }
}

#Preview {
    AuthButtonLabel()
}
