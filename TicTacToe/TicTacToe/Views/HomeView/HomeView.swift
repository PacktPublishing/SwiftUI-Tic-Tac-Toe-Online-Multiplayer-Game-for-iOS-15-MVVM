//
//  ContentView.swift
//  TicTacToe
//
//  Created by David Kababyan on 07/08/2021.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        
        VStack {
            Button {
                viewModel.isGameViewPresented = true
            } label: {
                GameButton(title: "Play", backgroundColor: Color(.systemGreen))
            }
        }
        .fullScreenCover(isPresented: $viewModel.isGameViewPresented) {
            GameView(viewModel: GameViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
