//
//  StatsSections.swift
//  SettingsPrototype
//
//  Created by David on 3/30/20.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

enum StatsSection: Int, CaseIterable, CustomStringConvertible {
    case generalStats
    case streaks
    
    var description: String {
        switch self {
        case.generalStats: return ""
        case.streaks: return "Streaks"
        }
    }
}

enum GeneralStats: Int, CaseIterable, CustomStringConvertible {
    case totalAdded
    case current
    case eaten
    case trashed
    case averageCompletion
    
    var description: String {
        switch self {
        case.totalAdded: return "Total added"
        case.current: return "Current"
        case.eaten: return "Eaten"
        case.trashed: return "Trashed"
        case.averageCompletion: return "Average completion"
        }
    }
    
    var stat: String {
        switch self {
        case.totalAdded: return "\(AvocadoController.shared.settings[0].totalAddedCount)"
        case.current: return "\(AvocadoController.shared.settings[0].currentCount)"
        case.eaten: return "\(AvocadoController.shared.settings[0].eatenCount)"
        case.trashed: return "\(AvocadoController.shared.settings[0].trashedCount)"
        case.averageCompletion:
            if AvocadoController.shared.settings[0].trashedCount == 0 && AvocadoController.shared.settings[0].eatenCount == 0 {
                return "0"
            } else {
                return "\((AvocadoController.shared.settings[0].eatenCount * 100) / (AvocadoController.shared.settings[0].eatenCount + AvocadoController.shared.settings[0].trashedCount))%"
            }
        }
    }
}

enum Streaks: Int, CaseIterable, CustomStringConvertible {
    case currentStreak
    case longestStreak
    
    var description: String {
        switch self {
        case.currentStreak: return "Current streak"
        case.longestStreak: return "Longest streak"
        }
    }
    
    var stat: String {
        switch self {
        case.currentStreak: return "\(AvocadoController.shared.settings[0].currentStreak)"
        case.longestStreak: return "\(AvocadoController.shared.settings[0].longestStreak)"
        }
    }
}
