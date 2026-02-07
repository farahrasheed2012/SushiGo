//
//  ScoringEngine.swift
//  SushiGo
//
//  Central scoring logic for all Sushi Go card types. Validates and computes
//  round scores and end-of-game pudding scoring.
//

import Foundation

enum ScoringEngine {

    // MARK: - Round scoring (all players' cards for one round)

    /// Computes round score for one player from their played cards this round.
    /// Nigiri + Wasabi ordering: Wasabi triples the *next* Nigiri.
    static func roundScore(for cards: [PlayedCard]) -> Int {
        var total = 0
        total += tempuraScore(cards)
        total += sashimiScore(cards)
        total += dumplingScore(cards)
        total += nigiriAndWasabiScore(cards)
        return total
    }

    /// Tempura: 5 points per pair.
    static func tempuraScore(_ cards: [PlayedCard]) -> Int {
        let count = cards.filter { $0.cardType == .tempura }.reduce(0) { $0 + $1.count }
        return (count / 2) * 5
    }

    /// Sashimi: 10 points per set of 3.
    static func sashimiScore(_ cards: [PlayedCard]) -> Int {
        let count = cards.filter { $0.cardType == .sashimi }.reduce(0) { $0 + $1.count }
        return (count / 3) * 10
    }

    /// Dumplings: 1, 3, 6, 10, 15 for 1, 2, 3, 4, 5+.
    static func dumplingScore(_ cards: [PlayedCard]) -> Int {
        let count = cards.filter { $0.cardType == .dumpling }.reduce(0) { $0 + $1.count }
        switch count {
        case 0: return 0
        case 1: return 1
        case 2: return 3
        case 3: return 6
        case 4: return 10
        default: return 15
        }
    }

    /// Nigiri: Squid=3, Salmon=2, Egg=1. Wasabi triples the next Nigiri (order matters).
    /// Cards are processed in order; each Wasabi applies to the next Nigiri.
    static func nigiriAndWasabiScore(_ cards: [PlayedCard]) -> Int {
        var total = 0
        var nextNigiriMultiplier = 1

        for card in cards {
            switch card.cardType {
            case .wasabi:
                nextNigiriMultiplier = 3
            case .nigiri:
                let base = card.nigiriType?.basePoints ?? 0
                total += base * nextNigiriMultiplier
                nextNigiriMultiplier = 1
            default:
                break
            }
        }
        return total
    }

    /// Maki: 6 for most, 3 for second-most, 0 others. Ties: split points (e.g. two-way tie for first = 4 each).
    static func makiScores(playersMakiCounts: [(playerId: UUID, count: Int)]) -> [UUID: Int] {
        guard !playersMakiCounts.isEmpty else { return [:] }

        let sorted = playersMakiCounts.sorted { $0.count > $1.count }
        var result: [UUID: Int] = [:]

        let firstCount = sorted[0].count
        let firstGroup = Array(sorted.prefix { $0.count == firstCount })
        let firstPoints: Int
        if firstGroup.count == 1 {
            firstPoints = 6
            for p in firstGroup { result[p.playerId] = 6 }
            let rest = sorted.dropFirst()
            guard let secondCount = rest.first?.count else { return result }
            let secondGroup = Array(rest.prefix { $0.count == secondCount })
            let secondPoints = secondGroup.count == 1 ? 3 : 3 / secondGroup.count
            for p in secondGroup { result[p.playerId] = secondPoints }
        } else {
            firstPoints = (6 + 3) / firstGroup.count
            for p in firstGroup { result[p.playerId] = firstPoints }
        }

        return result
    }

    /// Pudding at end of game: +6 most, -6 least. Ties split (e.g. two-way tie for least = -3 each).
    static func puddingScores(playersPuddingCounts: [(playerId: UUID, count: Int)]) -> [UUID: Int] {
        guard !playersPuddingCounts.isEmpty else { return [:] }
        if playersPuddingCounts.count == 1 {
            return [playersPuddingCounts[0].playerId: 0]
        }

        let sorted = playersPuddingCounts.sorted { $0.count > $1.count }
        var result: [UUID: Int] = [:]

        let maxCount = sorted[0].count
        let mostGroup = Array(sorted.prefix { $0.count == maxCount })
        let minCount = sorted.last?.count ?? 0
        let leastGroup = Array(sorted.filter { $0.count == minCount })

        let mostPoints = mostGroup.count == 1 ? 6 : 6 / mostGroup.count
        for p in mostGroup {
            result[p.playerId] = mostPoints
        }

        let leastPoints = leastGroup.count == 1 ? -6 : -6 / leastGroup.count
        for p in leastGroup {
            result[p.playerId] = leastPoints
        }

        for p in sorted where result[p.playerId] == nil {
            result[p.playerId] = 0
        }

        return result
    }

    /// Get Maki count from a player's round cards.
    static func makiCount(from cards: [PlayedCard]) -> Int {
        cards.filter { $0.cardType == .maki }.reduce(0) { $0 + $1.count }
    }
}
