//
//  Eventorias2App.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

import SwiftUI
import FirebaseCore

@main
struct Eventorias2App: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

///     @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
