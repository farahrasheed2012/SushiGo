# Sushi Go! Scoring App

A complete iOS scoring application for the Sushi Go! card game. Built with SwiftUI for iOS 15+.

## Features

- **2–5 players** with customizable names
- **3 rounds** with accurate scoring for all card types:
  - **Maki Rolls** — 6 / 3 / 0 points (most / second-most / others)
  - **Tempura** — 5 points per pair
  - **Sashimi** — 10 points per set of 3
  - **Dumplings** — 1 / 3 / 6 / 10 / 15 for 1 / 2 / 3 / 4 / 5+
  - **Nigiri** — Squid 3, Salmon 2, Egg 1 (×3 with Wasabi)
  - **Wasabi** — Triples the next Nigiri
  - **Pudding** — +6 most, −6 least (scored at end of game)
- Running totals after each round
- Final scores with winner announcement
- New game and “same players, play again” options
- Portrait and landscape support
- Sushi-themed UI

## Running in Xcode

1. Open `SushiGo.xcodeproj` in Xcode.
2. Select the **SushiGo** scheme and a simulator or device.
3. In **Signing & Capabilities**, choose your development team (required for device/simulator).
4. Press **Run** (⌘R).

## Project Structure

```
SushiGo/
├── SushiGoApp.swift          # App entry point
├── Models/
│   ├── CardType.swift        # Card types, Nigiri, PlayedCard
│   ├── GameState.swift       # GamePhase, RoundPlay
│   └── Player.swift          # Player model
├── Services/
│   └── ScoringEngine.swift   # All scoring rules
├── ViewModels/
│   └── GameViewModel.swift   # Game state & actions
├── Views/
│   ├── ContentView.swift     # Root (phase switching)
│   ├── PlayerSetupView.swift # 2–5 players, names
│   ├── GameView.swift        # Round scoring & card entry
│   ├── CardEntryView.swift   # Per-player card input
│   ├── RoundCompleteView.swift # Round summary
│   └── ResultsView.swift     # Final scores & winner
├── Utilities/
│   └── Theme.swift           # Colors & layout
├── Assets.xcassets
└── Info.plist
```

## Requirements

- Xcode 14+
- iOS 15.0+
- No external dependencies

## License

Use and modify as you like.
