//
//  imagePickerFirebaseApp.swift
//  imagePickerFirebase
//
//  Created by Roro Solutions on 15/01/23.
//

import SwiftUI
import Firebase

@main
struct imagePickerFirebaseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}
