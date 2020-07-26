//
//  Settings.swift
//  Avo Keepr
//
//  Created by David on 5/21/20.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

class Settings: Codable {
    var totalAddedCount: Int
    var currentCount: Int
    var eatenCount: Int
    var trashedCount: Int
    var currentStreak: Int
    var longestStreak: Int
    var avocadoNumber: Int
    var notificationHour: Int
    var notificationMinute: Int
    var notificationsAreEnabledLocally: Bool
    var notificationsPrimerPresented: Bool
    
    init(totalAddedCount: Int, currentCount: Int, eatenCount: Int, trashedCount: Int, currentStreak: Int, longestStreak: Int, avocadoNumber: Int, notificationHour: Int, notificationMinute: Int, notificationsAreEnabledLocally: Bool, notificationsPrimerPresented: Bool) {
        self.totalAddedCount = totalAddedCount
        self.currentCount = currentCount
        self.eatenCount = eatenCount
        self.trashedCount = trashedCount
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.avocadoNumber = avocadoNumber
        self.notificationHour = notificationHour
        self.notificationMinute = notificationMinute
        self.notificationsAreEnabledLocally = notificationsAreEnabledLocally
        self.notificationsPrimerPresented = notificationsPrimerPresented
    }
}
