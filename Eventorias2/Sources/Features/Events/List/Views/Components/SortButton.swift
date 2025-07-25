//
//  SortButton.swift
//  Eventorias2
//
//  Created by Alassane Der on 20/07/2025.
//

import SwiftUI

struct SortButton: View {
    @Environment(\.self) private var env

    var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }, label: {
            HStack(content: {
                Image("IconSort")
                Text(NSLocalizedString("Sort_button", comment: "Sort button"))
                    .font(.custom("Inter-Medium", size: 16))

            })
            .foregroundStyle(Color.primary)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.background_field(env)))
            .padding(.horizontal)
        })

    }
}

#Preview {
    SortButton()
}
