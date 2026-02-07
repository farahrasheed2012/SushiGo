//
//  ContentView.swift
//  SushiGo
//
//  Root view: switches between setup, game, round complete, and results.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.phase {
                case .setup:
                    PlayerSetupView(viewModel: viewModel)
                        .navigationBarHidden(true)

                case .round:
                    GameView(viewModel: viewModel)

                case .roundComplete(let round):
                    RoundCompleteView(viewModel: viewModel, completedRound: round)

                case .gameOver:
                    ResultsView(viewModel: viewModel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
