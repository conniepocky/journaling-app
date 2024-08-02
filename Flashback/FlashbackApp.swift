//
//  FlashbackApp.swift
//  Flashback
//
//  Created by Connie Waffles on 25/07/2023.
//

import SwiftUI
import Firebase

@main
struct FlashbackApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
