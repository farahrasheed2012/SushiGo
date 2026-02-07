//
//  ResultsView.swift
//  SushiGo
//
//  Final scores with pudding adjustment and winner announcement.
//

import SwiftUI

struct ResultsView: View {
    @ObservedObject var viewModel: GameViewModel

    private var sortedPlayers: [(player: Player, finalScore: Int)] {
        let scores = viewModel.finalScores
        return viewModel.players
            .map { (player: $0, finalScore: scores[$0.id] ?? 0) }
            .sorted { $0.finalScore > $1.finalScore }
    }

    private var winnerNames: String {
        guard let ids = viewModel.winnerIds else { return "" }
        return ids.compactMap { id in viewModel.players.first(where: { $0.id == id })?.name }
            .joined(separator: " & ")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.padding * 2) {
                Text("Game over!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primary)

                if !winnerNames.isEmpty {
                    Text("\(winnerNames) \((viewModel.winnerIds?.count ?? 1) > 1 ? "win" : "wins")!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.accent)
                        .padding(.horizontal)
                }

                VStack(spacing: Theme.smallPadding) {
                    ForEach(Array(sortedPlayers.enumerated()), id: \.element.player.id) { index, item in
                        HStack {
                            Text("\(index + 1).")
                                .font(.headline)
                                .frame(width: 24, alignment: .leading)
                            Text(item.player.name)
                                .foregroundColor(Theme.text)
                            Spacer()
                            Text("\(item.player.totalScore)")
                                .foregroundColor(Theme.textSecondary)
                            Text("+ \(puddingBonus(for: item.player))")
                                .font(.caption)
                                .foregroundColor(Theme.makiGreen)
                            Text("= \(item.finalScore)")
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.primary)
                        }
                        .padding()
                        .background(Theme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 8) {
                    Button(action: {
                        viewModel.newGame()
                    }) {
                        Text("New game")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primary)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }

                    Button(action: {
                        viewModel.playAgain()
                    }) {
                        Text("Same players, play again")
                            .font(.subheadline)
                            .foregroundColor(Theme.primary)
                    }
                }
                .padding(.top, 24)
            }
            .padding(Theme.padding)
        }
        .background(Theme.background)
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func puddingBonus(for player: Player) -> Int {
        let pudding = ScoringEngine.puddingScores(
            playersPuddingCounts: viewModel.players.map { ($0.id, $0.puddingCount) },
            playerCount: viewModel.players.count
        )
        return pudding[player.id] ?? 0
    }
}
