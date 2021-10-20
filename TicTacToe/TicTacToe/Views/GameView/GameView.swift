//
//  GameView.swift
//  GameView
//
//  Created by David Kababyan on 07/08/2021.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Text(viewModel.gameNotification)
                
                Button{
                    mode.wrappedValue.dismiss()
                    viewModel.quiteGame()
                } label: {
                    GameButton(title: "Quit", backgroundColor: Color(.systemRed))
                }
                
                if viewModel.game?.player2Id == "" {
                    LoadingView()
                }
                
                Spacer()
                
                VStack {
                    LazyVGrid(columns: viewModel.columns, spacing: 5) {
                        ForEach(0..<9) { i in
                            
                            ZStack {
                                GameSquareView(proxy: geometry)
                                PlayerIndicatorView(systemImageName: viewModel.game?.moves[i]?.indicator ?? "applelogo")
                            }
                            .onTapGesture {
                                viewModel.processPlayerMove(for: i)
                            }
                        }
                    }
                }
                .disabled(viewModel.checkForGameBoardStatus())
                .padding()
                .alert(item: $viewModel.alertItem) { alertItem in

                    alertItem.isForQuit ? Alert(title: alertItem.title, message: alertItem.message, dismissButton: .destructive(alertItem.buttonTitle, action: {
                        self.mode.wrappedValue.dismiss()
                        viewModel.quiteGame()
                    }))
                    : Alert(title: alertItem.title, message: alertItem.message, primaryButton: .default(alertItem.buttonTitle, action: {
                        viewModel.restGame()
                    }), secondaryButton: .destructive(Text("Quit"), action: {
                        self.mode.wrappedValue.dismiss()
                        viewModel.quiteGame()
                    }))
                    
                }
            }
        }.onAppear {
            viewModel.getTheGame()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}
