//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by David Kababyan on 07/08/2021.
//

import SwiftUI
import Firebase

@main
struct TicTacToeApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
