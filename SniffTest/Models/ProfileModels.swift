//
//  ProfileModels.swift
//  SniffTest
//
//  Created by OpenAI on 4/21/26.
//

import Foundation

enum ProfileAvatar: String, CaseIterable, Codable, Identifiable {
    case comet
    case mask
    case spark
    case bolt
    case wave
    case prism

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .comet:
            return "moon.stars.fill"
        case .mask:
            return "theatermasks.fill"
        case .spark:
            return "sparkles"
        case .bolt:
            return "bolt.fill"
        case .wave:
            return "dot.radiowaves.left.and.right"
        case .prism:
            return "diamond.fill"
        }
    }
}

enum AppLanguage: String, CaseIterable, Codable, Identifiable {
    case english = "English"
    case spanish = "Spanish"
    case french = "French"
    case german = "German"

    var id: String { rawValue }
}

struct ProfileStats: Codable, Equatable {
    var streak: Int
    var roomsPlayed: Int
    var accuracyRate: Int
    var bluffSuccessRate: Int
    var xp: Int
    var currentLevelXP: Int
    var nextLevelXP: Int

    static let guest = ProfileStats(
        streak: 3,
        roomsPlayed: 12,
        accuracyRate: 78,
        bluffSuccessRate: 66,
        xp: 420,
        currentLevelXP: 300,
        nextLevelXP: 600
    )
}

struct ProfileBadge: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let isUnlocked: Bool

    static let starterSet: [ProfileBadge] = [
        ProfileBadge(id: "first-room", title: "First Room", subtitle: "Hosted your first match", symbolName: "door.left.hand.open", isUnlocked: true),
        ProfileBadge(id: "truth-streak", title: "Truth Seeker", subtitle: "5 correct truth calls", symbolName: "checkmark.seal.fill", isUnlocked: true),
        ProfileBadge(id: "bluff-hunter", title: "Bluff Hunter", subtitle: "Expose 10 bluffs", symbolName: "eye.fill", isUnlocked: false),
        ProfileBadge(id: "crowd-favorite", title: "Crowd Favorite", subtitle: "Play 25 rooms", symbolName: "person.3.fill", isUnlocked: false)
    ]
}

struct ProfileState: Codable, Equatable {
    var nickname: String
    var avatar: ProfileAvatar
    var isGuestMode: Bool
    var notificationsEnabled: Bool
    var soundEnabled: Bool
    var language: AppLanguage
    var stats: ProfileStats
    var badges: [ProfileBadge]

    static let guest = ProfileState(
        nickname: "Guest Sleuth",
        avatar: .spark,
        isGuestMode: true,
        notificationsEnabled: true,
        soundEnabled: true,
        language: .english,
        stats: .guest,
        badges: ProfileBadge.starterSet
    )
}
