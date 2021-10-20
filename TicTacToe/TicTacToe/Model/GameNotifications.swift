//
//  GameNotifications.swift
//  GameNotifications
//
//  Created by David Kababyan on 19/08/2021.
//

import SwiftUI

enum GameState {
    case started
    case waitingForPlayer
    case finished
}


struct GameNotification {
    static let waitingForPlayer = "Waiting for player"
    static let gameHasStarted = "Game has started"
    static let gameFinished = "Player left the game"
}
