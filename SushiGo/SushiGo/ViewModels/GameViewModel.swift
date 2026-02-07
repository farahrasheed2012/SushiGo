//
//  GameViewModel.swift
//  SushiGo
//
//  Manages game state: players, rounds, card entry, and score calculation.
//

import Foundation
import SwiftUI

/// Observable game state for the Sushi Go scoring app.
final class GameViewModel: ObservableObject {
    // MARK: - Published state

    @Published private(set) var phase: GamePhase = .setup
    @Published var players: [Player] = []
    @Published var currentRound: Int = 1
    /// Cards entered for the current round, per player (playerId -> cards).
    @Published var roundCards: [UUID: [PlayedCard]] = [:]
    /// Pudding counts accumulated per player (updated each round).
    @Published var puddingCounts: [UUID: Int] = [:]

    // MARK: - Derived

    var playerCount: Int { players.count }
    var isSetup: Bool { if case .setup = phase { return true }; return false }
    var isGameOver: Bool { if case .gameOver = phase { return true }; return false }

    /// Running total (round scores only) per player.
    var runningTotals: [UUID: Int] {
        Dictionary(uniqueKeysWithValues: players.map { ($0.id, $0.totalScore) })
    }

    /// Final scores including pudding (only valid after game over).
    var finalScores: [UUID: Int] {
        guard isGameOver else { return [:] }
        let pudding = ScoringEngine.puddingScores(playersPuddingCounts: players.map { ($0.id, $0.puddingCount) })
        return Dictionary(uniqueKeysWithValues: players.map { id in
            (id.id, id.totalScore + (pudding[id.id] ?? 0))
        })
    }

    /// Winner player id(s) if tie; nil if not game over.
    var winnerIds: [UUID]? {
        guard isGameOver else { return nil }
        let scores = finalScores
        guard let maxScore = scores.values.max() else { return nil }
        return scores.filter { $0.value == maxScore }.map(\.key)
    }

    // MARK: - Setup

    func setPlayerCount(_ count: Int) {
        let count = min(5, max(2, count))
        if players.count != count {
            players = (0..<count).map { i in
                Player(name: "Player \(i + 1)")
            }
            resetRoundState()
        }
    }

    func setPlayerName(_ name: String, at index: Int) {
        guard index >= 0, index < players.count else { return }
        players[index].name = name.isEmpty ? "Player \(index + 1)" : name
    }

    func startGame() {
        guard players.count >= 2 else { return }
        roundCards = Dictionary(uniqueKeysWithValues: players.map { ($0.id, []) })
        puddingCounts = Dictionary(uniqueKeysWithValues: players.map { ($0.id, 0) })
        currentRound = 1
        phase = .round(1)
    }

    // MARK: - Round card entry

    func cards(forPlayerId id: UUID) -> [PlayedCard] {
        roundCards[id] ?? []
    }

    func addCard(_ card: PlayedCard, forPlayerId id: UUID) {
        roundCards[id, default: []].append(card)
        if card.cardType == .pudding {
            puddingCounts[id, default: 0] += card.count
        }
    }

    func removeCard(_ card: PlayedCard, forPlayerId id: UUID) {
        guard var list = roundCards[id] else { return }
        if let idx = list.firstIndex(where: { $0.id == card.id }) {
            let removed = list.remove(at: idx)
            if removed.cardType == .pudding {
                puddingCounts[id, default: 0] = max(0, (puddingCounts[id] ?? 0) - removed.count)
            }
            roundCards[id] = list
        }
    }

    func clearCards(forPlayerId id: UUID) {
        let had = roundCards[id] ?? []
        roundCards[id] = []
        let pudding = had.filter { $0.cardType == .pudding }.reduce(0) { $0 + $1.count }
        puddingCounts[id, default: 0] = max(0, (puddingCounts[id] ?? 0) - pudding)
    }

    // MARK: - Score round and advance

    func completeRound() {
        guard case .round(let r) = phase, r >= 1, r <= 3 else { return }

        let makiCounts = players.map { id -> (UUID, Int) in
            (id.id, ScoringEngine.makiCount(from: roundCards[id.id] ?? []))
        }
        let makiScores = ScoringEngine.makiScores(playersMakiCounts: makiCounts)

        for i in players.indices {
            let id = players[i].id
            let cards = roundCards[id] ?? []
            var roundTotal = ScoringEngine.roundScore(for: cards)
            roundTotal += makiScores[id] ?? 0
            players[i].setScore(roundTotal, forRound: r)
            players[i].puddingCount = puddingCounts[id] ?? 0
        }

        if r == 3 {
            phase = .gameOver
        } else {
            phase = .roundComplete(r)
            currentRound = r + 1
            roundCards = Dictionary(uniqueKeysWithValues: players.map { ($0.id, []) })
        }
    }

    /// Call after showing round complete to move to next round.
    func advanceToNextRound() {
        if case .roundComplete = phase {
            phase = .round(currentRound)
        }
    }

    // MARK: - Reset

    func resetRoundState() {
        roundCards = [:]
        puddingCounts = [:]
        currentRound = 1
    }

    func resetGame() {
        phase = .setup
        for i in players.indices {
            players[i].roundScores = [0, 0, 0]
            players[i].puddingCount = 0
        }
        resetRoundState()
    }

    func newGame() {
        resetGame()
        players = (0..<players.count).map { i in Player(name: "Player \(i + 1)") }
    }

    /// Keep same players and names; reset scores and start round 1.
    func playAgain() {
        for i in players.indices {
            players[i].roundScores = [0, 0, 0]
            players[i].puddingCount = 0
        }
        roundCards = Dictionary(uniqueKeysWithValues: players.map { ($0.id, []) })
        puddingCounts = Dictionary(uniqueKeysWithValues: players.map { ($0.id, 0) })
        currentRound = 1
        phase = .round(1)
    }
}
