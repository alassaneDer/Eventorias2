//
//  ProfilPic.swift
//  Eventorias2
//
//  Created by Alassane Der on 20/07/2025.
//

import SwiftUI

struct AsyncImagView: View {
    
    var imageURL: URL? = URL(string: "pexels1")
    var imageWidth: CGFloat = 40.0
    var imageHeight: CGFloat = 40.0
    
    var body: some View {
        
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageWidth, height: imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
        } placeholder: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.gray)
        }
    }
}

#Preview {
    AsyncImagView()
}
