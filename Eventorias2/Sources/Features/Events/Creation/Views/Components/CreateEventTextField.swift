//
//  CreateEventTextField.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import SwiftUI

struct CreateEventTextField: View {
    @Environment(\.self) private var env
    var title: String = "username"
    var value: Binding<String> = .constant("placeholder")
    let placeholder: LocalizedStringKey

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Inter-Regular", size: 14))
                .foregroundStyle(Color.secondary)
            TextField(placeholder, text: value)
                .font(.custom("Inter-Regular", size: 16))
                .foregroundStyle(Color.primary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 4.0).fill(Color.background_field(env)))
    }
}
