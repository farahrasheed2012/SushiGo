//
//  CardEntryView.swift
//  SushiGo
//
//  Per-player card entry: add/remove cards for the current round.
//

import SwiftUI

struct CardEntryView: View {
    @ObservedObject var viewModel: GameViewModel
    let playerId: UUID
    let playerName: String

    @State private var showNigiriPicker = false
    @State private var pendingWasabi = false

    private var cards: [PlayedCard] {
        viewModel.cards(forPlayerId: playerId)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallPadding) {
            HStack {
                Text(playerName)
                    .font(.headline)
                    .foregroundColor(Theme.text)
                Spacer()
                Button("Clear") {
                    viewModel.clearCards(forPlayerId: playerId)
                }
                .font(.subheadline)
                .foregroundColor(Theme.primary)
            }

            // Quick-add buttons by card type (no Nigiri subtype yet)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(CardType.roundScored + [.pudding]) { type in
                        if type == .nigiri {
                            nigiriButtons
                        } else {
                            addButton(for: type)
                        }
                    }
                }
                .padding(.vertical, 4)
            }

            // List of added cards (tappable to remove)
            if !cards.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(cards) { card in
                            cardChip(card)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(Theme.padding)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(Theme.textSecondary.opacity(0.3), lineWidth: 1)
        )
        .sheet(isPresented: $showNigiriPicker) {
            nigiriPickerSheet
        }
    }

    private var nigiriButtons: some View {
        HStack(spacing: 4) {
            ForEach(NigiriType.allCases) { nigiri in
                Button(action: {
                    viewModel.addCard(PlayedCard.nigiri(nigiri, wasabi: false), forPlayerId: playerId)
                }) {
                    Text(nigiri.displayName)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Theme.accent.opacity(0.3))
                        .clipShape(Capsule())
                }
                .foregroundColor(Theme.text)
            }
            Button("+ Wasabi") {
                viewModel.addCard(PlayedCard(cardType: .wasabi, count: 1), forPlayerId: playerId)
            }
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Theme.makiGreen.opacity(0.3))
            .clipShape(Capsule())
            .foregroundColor(Theme.text)
        }
    }

    private func addButton(for type: CardType) -> some View {
        Button(action: {
            addOne(type)
        }) {
            Text(type.shortName)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Theme.primary.opacity(0.15))
                .foregroundColor(Theme.primary)
                .clipShape(Capsule())
        }
    }

    private func addOne(_ type: CardType) {
        if type == .maki {
            viewModel.addCard(PlayedCard.simple(.maki, count: 1), forPlayerId: playerId)
        } else if type == .tempura {
            viewModel.addCard(PlayedCard.simple(.tempura, count: 1), forPlayerId: playerId)
        } else if type == .sashimi {
            viewModel.addCard(PlayedCard.simple(.sashimi, count: 1), forPlayerId: playerId)
        } else if type == .dumpling {
            viewModel.addCard(PlayedCard.simple(.dumpling, count: 1), forPlayerId: playerId)
        } else if type == .pudding {
            viewModel.addCard(PlayedCard.simple(.pudding, count: 1), forPlayerId: playerId)
        }
    }

    private func cardChip(_ card: PlayedCard) -> some View {
        Group {
            if card.cardType == .nigiri, let nigiri = card.nigiriType {
                Text("\(card.hasWasabi ? "Wasabi+" : "")\(nigiri.displayName)")
            } else {
                Text("\(card.cardType.shortName)\(card.count > 1 ? " ×\(card.count)" : "")")
            }
        }
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Theme.primary.opacity(0.2))
        .foregroundColor(Theme.text)
        .clipShape(Capsule())
        .onTapGesture {
            viewModel.removeCard(card, forPlayerId: playerId)
        }
    }

    private var nigiriPickerSheet: some View {
        NavigationView {
            VStack(spacing: 16) {
                Toggle("With Wasabi", isOn: $pendingWasabi)
                    .padding()
                ForEach(NigiriType.allCases) { nigiri in
                    Button(action: {
                        viewModel.addCard(PlayedCard.nigiri(nigiri, wasabi: pendingWasabi), forPlayerId: playerId)
                        showNigiriPicker = false
                    }) {
                        Text(nigiri.displayName)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .background(Theme.accent.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Add Nigiri")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showNigiriPicker = false }
                }
            }
        }
    }
}

