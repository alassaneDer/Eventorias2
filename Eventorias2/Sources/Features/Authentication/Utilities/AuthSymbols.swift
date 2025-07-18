//
//  AuthSymbols.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import SwiftUI

enum AuthSymbols: String {
    case person = "person.fill"
    case lock = "lock.fill"
    case envelope = "envelope.fill"
    case eye = "eye.fill"
    case eyeSlash = "eye.slash.fill"
    
    var image: Image {
        Image(systemName: rawValue)
    }
}
