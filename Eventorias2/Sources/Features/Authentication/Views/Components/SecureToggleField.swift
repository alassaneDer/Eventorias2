//
//  SecureToggleField.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import SwiftUI

struct SecureToggleField: View {
    
    let placeholder: LocalizedStringKey
    @Binding var text: String
    @Binding var isSecured: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: AuthSymbols.lock.rawValue)
                    .foregroundStyle(.primary)
                
                if isSecured {
                    SecureField(placeholder, text: $text)
                        .font(.custom("Inter-Regular", size: 16))
                } else {
                    TextField(placeholder, text: $text)
                        .font(.custom("Inter-Regular", size: 16))
                }
                
                Button(action: {
                    withAnimation(.bouncy) {
                        isSecured.toggle()
                    }
                }) {
                    Image(systemName: isSecured ? AuthSymbols.eyeSlash.rawValue : AuthSymbols.eye.rawValue)
                        .foregroundStyle(.primary)
                }
            }
            .padding(.vertical, 8)
        }
        Divider()
        
    }
}

#Preview {
    SecureToggleField(placeholder: "password", text: .constant(""), isSecured: .constant(true))
}
