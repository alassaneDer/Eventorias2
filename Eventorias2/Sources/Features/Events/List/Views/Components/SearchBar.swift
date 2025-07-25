//
//  SearchBar.swift
//  Eventorias2
//
//  Created by Alassane Der on 20/07/2025.
//

import SwiftUI

struct SearchBar: View {
    
    var text: Binding<String> = .constant("Search")
    @Environment(\.self) private var env

    var body: some View {
        HStack(content: {
            Image(systemName: "magnifyingglass")
            
            TextField(NSLocalizedString("Search_placeholder", comment: "Search placeholder "), text: text)
                .font(.custom("Inter-Medium", size: 16))
                .textInputAutocapitalization(.never)
        })
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.background_field(env)))
        .padding(.horizontal)
    }
}

#Preview {
    SearchBar()
}
