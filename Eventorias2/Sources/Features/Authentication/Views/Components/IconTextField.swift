//
//  IconTextField.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import SwiftUI

struct IconTextField: View {
    let icon: AuthSymbols
    let placeholder: LocalizedStringKey
    @Binding var text: String
    
    var body: some View {
        
        HStack(content: {
            icon.image
             
            TextField(placeholder, text: $text)
                .font(.custom("Inter-Regular", size: 16))
                .padding(.vertical, 8)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        })
        Divider()
    }
}

#Preview {
    IconTextField(icon: .envelope, placeholder: "name", text: .constant(""))
}
