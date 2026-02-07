//
//  CardType.swift
//  SushiGo
//
//  Models all Sushi Go card types and Nigiri variants for scoring.
//

import Foundation
import SwiftUI

// MARK: - Card Type

/// All playable card types in Sushi Go (scoring rules in ScoringEngine).
enum CardType: String, CaseIterable, Identifiable, Codable {
    case maki
    case tempura
    case sashimi
    case dumpling
    case nigiri
    case wasabi
    case pudding

    var id: String { rawValue }

    /// Display name for UI.
    var displayName: String {
        switch self {
        case .maki: return "Maki Roll"
        case .tempura: return "Tempura"
        case .sashimi: return "Sashimi"
        case .dumpling: return "Dumpling"
        case .nigiri: return "Nigiri"
        case .wasabi: return "Wasabi"
        case .pudding: return "Pudding"
        }
    }

    /// Short label for compact UI (e.g. "Maki", "Temp").
    var shortName: String {
        switch self {
        case .maki: return "Maki"
        case .tempura: return "Tempura"
        case .sashimi: return "Sashimi"
        case .dumpling: return "Dumpling"
        case .nigiri: return "Nigiri"
        case .wasabi: return "Wasabi"
        case .pudding: return "Pudding"
        }
    }

    /// Card types that are scored at end of round (not pudding).
    static var roundScored: [CardType] {
        [.maki, .tempura, .sashimi, .dumpling, .nigiri]
    }

    /// Pudding is scored only at end of game.
    static var gameEndScored: CardType { .pudding }
}

// MARK: - Nigiri Type

/// Nigiri variety; each has a base point value (doubled by Wasabi in scoring).
enum NigiriType: String, CaseIterable, Identifiable, Codable {
    case squid   // 3
    case salmon  // 2
    case egg     // 1

    var id: String { rawValue }

    var basePoints: Int {
        switch self {
        case .squid: return 3
        case .salmon: return 2
        case .egg: return 1
        }
    }

    var displayName: String {
        switch self {
        case .squid: return "Squid"
        case .salmon: return "Salmon"
        case .egg: return "Egg"
        }
    }
}

// MARK: - Played Card (for round collection)

/// A single played card: either a generic count (e.g. 2 Tempura) or Nigiri with type and wasabi.
struct PlayedCard: Identifiable, Equatable, Codable {
    let id: UUID
    let cardType: CardType
    var count: Int
    var nigiriType: NigiriType?
    var hasWasabi: Bool

    init(
        id: UUID = UUID(),
        cardType: CardType,
        count: Int = 1,
        nigiriType: NigiriType? = nil,
        hasWasabi: Bool = false
    ) {
        self.id = id
        self.cardType = cardType
        self.count = count
        self.nigiriType = nigiriType
        self.hasWasabi = hasWasabi
    }

    static func simple(_ type: CardType, count: Int = 1) -> PlayedCard {
        PlayedCard(cardType: type, count: count)
    }

    static func nigiri(_ type: NigiriType, wasabi: Bool = false) -> PlayedCard {
        PlayedCard(cardType: .nigiri, count: 1, nigiriType: type, hasWasabi: wasabi)
    }
}
