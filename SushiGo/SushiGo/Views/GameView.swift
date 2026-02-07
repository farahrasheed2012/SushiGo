//
//  GameView.swift
//  SushiGo
//
//  Main game screen: round number, score summary, card entry per player, complete round.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.padding) {
                // Header: round and scores
                HStack {
                    Text("Round \(viewModel.currentRound)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.primary)
                    Spacer()
                }

                scoreSummary

                Text("Cards this round")
                    .font(.headline)
                    .foregroundColor(Theme.text)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(viewModel.players) { player in
                    CardEntryView(
                        viewModel: viewModel,
                        playerId: player.id,
                        playerName: player.name
                    )
                }

                Button(action: {
                    viewModel.completeRound()
                }) {
                    Text(viewModel.currentRound == 3 ? "Finish game" : "Complete round")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.primary)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
                .padding(.top, 8)
            }
            .padding(Theme.padding)
        }
        .background(Theme.background)
        .navigationTitle("Sushi Go")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("New game") {
                    viewModel.resetGame()
                }
                .foregroundColor(Theme.primary)
            }
        }
    }

    private var scoreSummary: some View {
        VStack(spacing: Theme.smallPadding) {
            ForEach(viewModel.players) { player in
                HStack {
                    Text(player.name)
                        .foregroundColor(Theme.text)
                    Spacer()
                    Text("\(viewModel.runningTotals[player.id] ?? 0) pts")
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.primary)
                    if viewModel.currentRound >= 1 {
                        Text("(R1: \(player.score(forRound: 1)))")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                    if viewModel.currentRound >= 2 {
                        Text("R2: \(player.score(forRound: 2))")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                    if viewModel.currentRound >= 3 {
                        Text("R3: \(player.score(forRound: 3))")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            }
        }
    }
}
