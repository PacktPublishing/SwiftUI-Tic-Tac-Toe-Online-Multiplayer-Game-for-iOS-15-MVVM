//
//  GameViewModel.swift
//  GameViewModel
//
//  Created by David Kababyan on 09/08/2021.
//

import SwiftUI
import Combine

final class GameViewModel: ObservableObject {

    @AppStorage("user") private var userData: Data?
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]

    @Published var game: Game? {
        didSet {
            checkIfGameIsOver()
            //check the game status
            
            if game == nil { updateGameNotificationFor(.finished) } else {
                game?.player2Id == "" ? updateGameNotificationFor(.waitingForPlayer) : updateGameNotificationFor(.started)
            }
        }
    }
    
    @Published var gameNotification = GameNotification.waitingForPlayer
    @Published var currentUser: User!
    @Published var alertItem: AlertItem?
    
    private var cancellables: Set<AnyCancellable> = []

    private let winPatterns: Set<Set<Int>> = [ [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6] ]
    
    init() {
        retriveUser()
        if currentUser == nil {
            saveUser()
        }
    }
    
    
    func getTheGame() {
        FirebaseService.shared.startGame(with: currentUser.id)
        
        FirebaseService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }
    
    func processPlayerMove(for position: Int) {
        
        guard game != nil else { return }
        
        if isSquareOccupied(in: game!.moves, forIndex: position) { return }
        
        game!.moves[position] = Move(isPlayer1: isPlayerOne(), boardIndex: position)
        game!.blockMoveForPlayerId = currentUser.id
        
        FirebaseService.shared.updateGame(game!)

        if checkForWinCondition(for: isPlayerOne(), in: game!.moves) {
            game!.winningPlayerId = currentUser.id
            print("you have won!")
            FirebaseService.shared.updateGame(game!)
            return
        }
        
        
        if checkForDraw(in: game!.moves) {
            game!.winningPlayerId = "0"
            print("Draw!")
            FirebaseService.shared.updateGame(game!)
            return
        }
    }
    
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    
    func checkForWinCondition(for player1: Bool, in moves: [Move?]) -> Bool {
        //remove all nils
        let playerMoves = moves.compactMap { $0 }.filter{ $0.isPlayer1 == player1 }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        
        return moves.compactMap { $0 }.count == 9
    }
    
    
    func quiteGame() {
        FirebaseService.shared.quiteTheGame()
    }
    
    func checkForGameBoardStatus() -> Bool {
        return game != nil ? game!.blockMoveForPlayerId == currentUser.id : false
    }
    
    
    func isPlayerOne() -> Bool {
        return game != nil ? game!.player1Id == currentUser.id : false
    }
    
    
    func checkIfGameIsOver() {
        alertItem = nil
        
        guard game != nil else { return }
        
        if game!.winningPlayerId == "0" {
            alertItem = AlertContext.draw
            
        } else if game!.winningPlayerId != "" {
            
            if game!.winningPlayerId == currentUser.id {
                alertItem = AlertContext.youWin
            } else {
                alertItem = AlertContext.youLost
            }
        }
    }
    
    func restGame() {
        
        guard game != nil else {
            alertItem = AlertContext.quit
            return
        }
        
        if game!.rematchPlayerId.count == 1 {
            //start new game
            game!.moves = Array(repeating: nil, count: 9)
            game!.winningPlayerId = ""
            game!.blockMoveForPlayerId = game!.player2Id
            
        } else if game!.rematchPlayerId.count == 2 {
            game!.rematchPlayerId = []
        }
        
        game!.rematchPlayerId.append(currentUser.id)
        
        FirebaseService.shared.updateGame(game!)
    }
    
    
    func updateGameNotificationFor(_ state: GameState) {
        
        switch state {
        case .started:
            gameNotification = GameNotification.gameHasStarted
        case .waitingForPlayer:
            gameNotification = GameNotification.waitingForPlayer
        case .finished:
            gameNotification = GameNotification.gameFinished
        }
    }
    
    //MARK: - User object
    func saveUser() {
        currentUser = User()
        do {
            print("encoding user object")
            let data = try JSONEncoder().encode(currentUser)
            userData = data
        } catch {
            print("couldnt same user object")
        }
        
    }
    
    func retriveUser() {
        
        guard let userData = userData else { return }
        
        do {
            print("decoding user")
            currentUser = try JSONDecoder().decode(User.self, from: userData)
        } catch {
            print("no user saved")
        }
    }

}

