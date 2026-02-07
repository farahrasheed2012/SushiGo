//
//  Player.swift
//  SushiGo
//
//  Represents a player and their round-by-round scores and pudding count.
//

import Foundation

struct Player: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    /// Scores per round (indices 0, 1, 2 for rounds 1–3).
    var roundScores: [Int]
    /// Total pudding count across all rounds (scored at end of game).
    var puddingCount: Int

    init(
        id: UUID = UUID(),
        name: String,
        roundScores: [Int] = [0, 0, 0],
        puddingCount: Int = 0
    ) {
        self.id = id
        self.name = name.isEmpty ? "Player" : name
        self.roundScores = roundScores
        self.puddingCount = puddingCount
    }

    /// Total score from rounds (before pudding).
    var totalScore: Int {
        roundScores.reduce(0, +)
    }

    /// Score for a specific round (1-based).
    func score(forRound round: Int) -> Int {
        let index = round - 1
        guard index >= 0, index < roundScores.count else { return 0 }
        return roundScores[index]
    }

    mutating func setScore(_ score: Int, forRound round: Int) {
        let index = round - 1
        guard index >= 0, index < roundScores.count else { return }
        roundScores[index] = score
    }

    mutating func addPudding(_ count: Int) {
        puddingCount += count
    }
}
