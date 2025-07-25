//
//  EventPic.swift
//  Eventorias2
//
//  Created by Alassane Der on 20/07/2025.
//
import SwiftUI

struct EventPic: View {
    var imageName: String = "event1"
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 136, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
}

#Preview {
    EventPic()
}
