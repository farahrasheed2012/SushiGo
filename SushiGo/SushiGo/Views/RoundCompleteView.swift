//
//  RoundCompleteView.swift
//  SushiGo
//
//  Shown after a round is scored; shows round totals and continues to next round or results.
//

import SwiftUI

struct RoundCompleteView: View {
    @ObservedObject var viewModel: GameViewModel
    let completedRound: Int

    var body: some View {
        VStack(spacing: Theme.padding * 2) {
            Text("Round \(completedRound) complete!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Theme.primary)

            VStack(alignment: .leading, spacing: Theme.smallPadding) {
                ForEach(viewModel.players) { player in
                    HStack {
                        Text(player.name)
                        Spacer()
                        Text("+\(player.score(forRound: completedRound)) this round")
                            .foregroundColor(Theme.textSecondary)
                        Text("Total: \(viewModel.runningTotals[player.id] ?? 0)")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
            }
            .padding(.horizontal)

            Button(action: {
                viewModel.advanceToNextRound()
            }) {
                Text(completedRound == 3 ? "See results" : "Next round")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.primary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            }
            .padding(.horizontal, Theme.padding)
        }
        .padding(Theme.padding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
}
