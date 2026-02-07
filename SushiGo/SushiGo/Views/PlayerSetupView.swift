//
//  PlayerSetupView.swift
//  SushiGo
//
//  Setup screen: choose 2–5 players and enter names.
//

import SwiftUI

struct PlayerSetupView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var selectedCount: Int = 2

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.padding * 2) {
                Text("Sushi Go!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primary)

                Text("Number of players")
                    .font(.headline)
                    .foregroundColor(Theme.text)

                HStack(spacing: Theme.smallPadding) {
                    ForEach(2...5, id: \.self) { count in
                        Button(action: {
                            selectedCount = count
                            viewModel.setPlayerCount(count)
                        }) {
                            Text("\(count)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(width: 44, height: 44)
                                .background(selectedCount == count ? Theme.primary : Theme.surface)
                                .foregroundColor(selectedCount == count ? .white : Theme.text)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Theme.primary, lineWidth: selectedCount == count ? 0 : 2)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("Player names")
                    .font(.headline)
                    .foregroundColor(Theme.text)
                    .padding(.top, 8)

                VStack(spacing: Theme.smallPadding) {
                    ForEach(Array(viewModel.players.enumerated()), id: \.element.id) { index, player in
                        HStack {
                            Text("Player \(index + 1)")
                                .frame(width: 70, alignment: .leading)
                                .foregroundColor(Theme.textSecondary)
                            TextField("Name", text: Binding(
                                get: { player.name },
                                set: { viewModel.setPlayerName($0, at: index) }
                            ))
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.words)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)

                Button(action: {
                    viewModel.startGame()
                }) {
                    Text("Start Game")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.players.count >= 2 ? Theme.primary : Theme.textSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
                .disabled(viewModel.players.count < 2)
                .padding(.top, 24)
            }
            .padding(Theme.padding)
        }
        .background(Theme.background)
        .onAppear {
            viewModel.setPlayerCount(selectedCount)
        }
        .onChange(of: selectedCount) { _ in
            viewModel.setPlayerCount(selectedCount)
        }
    }
}
