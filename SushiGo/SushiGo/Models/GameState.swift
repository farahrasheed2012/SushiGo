//
//  GameState.swift
//  SushiGo
//
//  High-level game phase and round/player data for state management.
//

import Foundation

/// Current phase of the game flow.
enum GamePhase: Equatable {
    case setup
    case round(Int)           // 1, 2, or 3
    case roundComplete(Int)   // round just finished
    case gameOver
}

/// Immutable snapshot of one round's played cards per player (for scoring).
struct RoundPlay {
    /// Player id -> cards played this round.
    let plays: [UUID: [PlayedCard]]

    func cards(forPlayerId id: UUID) -> [PlayedCard] {
        plays[id] ?? []
    }
}
