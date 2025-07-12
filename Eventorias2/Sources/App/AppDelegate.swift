//
//  AppDelegate.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

import Foundation
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

      return true
  }
}
