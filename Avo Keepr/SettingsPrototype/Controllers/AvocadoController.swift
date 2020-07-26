//
//  AvocadoController.swift
//  SettingsPrototype
//
//  Created by David on 4/12/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import UserNotifications

class AvocadoController {
    
    static let shared = AvocadoController()
    
    init() {
        loadFromPersistence()
    }
    
    var avocados = [Avocado]()
    var settings: [Settings] = []
    
    let dueTimeInterval = 129600.0
    let secondsInADay = 86400.0
    let secondsInADayAndAHalf = 129600.0
    let secondsIn12Hours = 43200.0
    
    func snoozeAvocado(uuid: String, days: Int) {
        
        let secondsToAdd: Double
        
        if days == 1 {
            secondsToAdd = -secondsInADay
        } else if days == 2 {
            secondsToAdd = 0
        } else {
            secondsToAdd = secondsInADay
        }
        
        if let avocadoToSnooze = avocados.first(where: {$0.uuid == uuid}) {
            avocadoToSnooze.due = false
            avocadoToSnooze.lastMovedTimestamp = Date() + secondsToAdd
        }
        saveToPersistentStorage()
    }
    
    func checkIfDueAndFlipAttribute() {
        
        let notRipe = AvocadoController.shared.avocados.filter({$0.table == 0})
        let almostRipe = AvocadoController.shared.avocados.filter({$0.table == 1})
        let ripe = AvocadoController.shared.avocados.filter({$0.table == 2})
        let currentAvocados = notRipe + almostRipe + ripe
        
        for avocado in currentAvocados {
            if Date().timeIntervalSince(avocado.lastMovedTimestamp) > dueTimeInterval {
                avocado.due = true
            }
        }
        saveToPersistentStorage()
    }
    
    func formulateMessageLabel() -> String {
        
        let dueAvocados = avocados.filter({$0.due == true})
        let ripeDue = dueAvocados.filter({$0.table == 2}).count
        let almostRipeDue = dueAvocados.filter({$0.table == 1}).count
        let notRipeDue = dueAvocados.filter({$0.table == 0}).count
        
        if settings[0].totalAddedCount == 0 {
            return "Tap the add button below to add your first avocado."
        } else if settings[0].currentCount == 0 {
            return "No more avocados? Come on back when you have some to track!."
        } else if ripeDue > 0 {
            return "Ripe avocados may be going bad. Tap snooze if they are still ripe or move them to the eaten or trashed."
        } else if almostRipeDue > 0 {
            return "Almost ripe avocados may be ripe. Tap snooze if they are still almost ripe or move to the ripe section."
        } else if notRipeDue > 0 {
            return "Not ripe avocados may be almost ripe. Tap snooze if they are still not ripe or move to the almost ripe section."
        } else {
            return "All avocados up to date."
        }
    }
    
    func returnMessageIconImage() -> UIImage? {
        
        let dueAvocados = avocados.filter({$0.due == true})
        let ripeDue = dueAvocados.filter({$0.table == 2}).count
        let almostRipeDue = dueAvocados.filter({$0.table == 1}).count
        let notRipeDue = dueAvocados.filter({$0.table == 0}).count
        let circleAlert = UIImage(systemName: "exclamationmark.circle.fill")!
        let redCircleAlert = circleAlert.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        let triangleAlert = UIImage(systemName: "exclamationmark.triangle.fill")!
        let yellowTriangleAlert = triangleAlert.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        
        if settings[0].totalAddedCount == 0 {
            return nil
        } else if ripeDue > 0 {
            return redCircleAlert
        } else if almostRipeDue > 0 {
            return yellowTriangleAlert
        } else if notRipeDue > 0 {
            return yellowTriangleAlert
        } else {
            return nil
        }
    }
    
    func addNotRipeAvocado(count: Int) {
        for _ in 0..<count {
            let avocado = Avocado(table: 0, number: settings[0].avocadoNumber)
            add(avocado)
        }
    }
    
    func addAlmostRipeAvocado(count: Int) {
        for _ in 0..<count {
            let avocado = Avocado(table: 1, number: settings[0].avocadoNumber)
            add(avocado)
        }
    }
    
    func addRipeAvocado(count: Int) {
        for _ in 0..<count {
            let avocado = Avocado(table: 2, number: settings[0].avocadoNumber)
            add(avocado)
        }
    }
    
    func add(_ avocado: Avocado) {
        avocados.append(avocado)
        settings[0].avocadoNumber += 1
        settings[0].totalAddedCount += 1
        settings[0].currentCount += 1
        
        scheduleUpcomingNotification()
        saveToPersistentStorage()
    }
    
    func moveToNotRipe(uuid: String) {
        if let avocadoToUpdate = avocados.first(where: {$0.uuid == uuid}) {
            avocadoToUpdate.table = 0
            avocadoToUpdate.lastMovedTimestamp = Date()
            avocadoToUpdate.due = false
        }
        saveToPersistentStorage()
    }
    
    func moveToAlmostRipe(uuid: String) {
        if let avocadoToUpdate = avocados.first(where: {$0.uuid == uuid}) {
            avocadoToUpdate.table = 1
            avocadoToUpdate.lastMovedTimestamp = Date()
            avocadoToUpdate.due = false
        }
        saveToPersistentStorage()
    }
    
    func moveToRipe(uuid: String) {
        if let avocadoToUpdate = avocados.first(where: {$0.uuid == uuid}) {
            avocadoToUpdate.table = 2
            avocadoToUpdate.lastMovedTimestamp = Date()
            avocadoToUpdate.due = false
        }
        saveToPersistentStorage()
    }
    
    func moveToEaten(uuid: String) {
        if let avocadoToUpdate = avocados.first(where: {$0.uuid == uuid}) {
            avocadoToUpdate.table = 3
            avocadoToUpdate.lastMovedTimestamp = Date()
            settings[0].eatenCount += 1
            settings[0].currentCount -= 1
            settings[0].currentStreak += 1
            if settings[0].currentStreak > settings[0].longestStreak {
                settings[0].longestStreak += 1
            }
        }
        saveToPersistentStorage()
    }
    
    func moveToTrashed(uuid: String) {
        if let avocadoToUpdate = avocados.first(where: {$0.uuid == uuid}) {
            avocadoToUpdate.table = 4
            avocadoToUpdate.lastMovedTimestamp = Date()
            settings[0].trashedCount += 1
            settings[0].currentCount -= 1
            settings[0].currentStreak = 0
        }
        saveToPersistentStorage()
    }
    
    @objc func flipToDue(uuid: String) {
        if let avocadoToUpdate = avocados.first(where: {$0.uuid == uuid}) {
            avocadoToUpdate.due = true
        }
        saveToPersistentStorage()
    }
    
    func delete(uuid: String) {
        let avocadoIndex = avocados.firstIndex(where: {$0.uuid == uuid})
        avocados.remove(at: avocadoIndex!)
        settings[0].totalAddedCount -= 1
        settings[0].currentCount -= 1
        saveToPersistentStorage()
    }
    
    func notificationsSwitchToggled() {
        if settings[0].notificationsAreEnabledLocally == false {
            settings[0].notificationsAreEnabledLocally = true
        } else {
            settings[0].notificationsAreEnabledLocally = false
        }
        saveToPersistentStorage()
    }
    
    func presentAddAvocadoAlert() -> AddAvocadoAlertViewController {
        let storyboard = UIStoryboard(name: "AddAvocadoAlert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AddAvocadoAlertVC") as! AddAvocadoAlertViewController
        return alertVC
    }
}

extension AvocadoController {
    
    func setNotificationTime(hour: Int, minute: Int) {
        settings[0].notificationHour = hour
        settings[0].notificationMinute = minute
        saveToPersistentStorage()
    }
    
    func setNotificationsAreEnabledLocally(to bool: Bool) {
        settings[0].notificationsAreEnabledLocally = bool
        saveToPersistentStorage()
    }
    
    func scheduleUpcomingNotification(){
        clearBadge()
        guard settings[0].notificationsAreEnabledLocally == true else {return}
        guard settings[0].currentCount != 0 else {return}
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Avocados are due!"
        content.body = "Your avocados may need updating or eating. Tap to update them."
        content.badge = NSNumber(value: 1)
        
        var selectedNotificationTime = DateComponents()
        selectedNotificationTime.hour = settings[0].notificationHour
        selectedNotificationTime.minute = settings[0].notificationMinute
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: calculateTriggerTimeInterval(), repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func calculateTriggerTimeInterval() -> Double {
        
        let notRipe = AvocadoController.shared.avocados.filter({$0.table == 0})
        let almostRipe = AvocadoController.shared.avocados.filter({$0.table == 1})
        let ripe = AvocadoController.shared.avocados.filter({$0.table == 2})
        let currentAvocados = notRipe + almostRipe + ripe
        
        var lastMovedTimes: [Date] = []
        for avocado in currentAvocados {
            lastMovedTimes.append(avocado.lastMovedTimestamp)
        }
        
        guard let nextDueAvocadoLastMovedTimestamp = lastMovedTimes.min() else {return timeIntervalToNextSelectedNotificationTime()}
        var days = 0.0
        
        if timeIntervalToNextSelectedNotificationTime() < secondsIn12Hours {
            days += 1
        }
        
        let nextSelectedTimeAsDate = Date() + timeIntervalToNextSelectedNotificationTime()
        let secondsFromNextDueLastMovedTilNextSelectedTime = nextSelectedTimeAsDate.timeIntervalSince(nextDueAvocadoLastMovedTimestamp)
        
        if secondsFromNextDueLastMovedTilNextSelectedTime > secondsInADay {
            days += 0
        } else if secondsFromNextDueLastMovedTilNextSelectedTime > 0 {
            days += 1
        }else if secondsFromNextDueLastMovedTilNextSelectedTime > -secondsInADayAndAHalf {
            days += 2
        } else {
            days += 0
            print("Error in calculating time")
        }
        
        let time = timeIntervalToNextSelectedNotificationTime() + days*secondsInADay
        return time
    }
    
    func timeIntervalToNextSelectedNotificationTime() -> Double {
        let setTimeComponents = DateComponents(hour: settings[0].notificationHour, minute: settings[0].notificationMinute)
        let nextSetTimeDate = Calendar.current.nextDate(after: Date(), matching: setTimeComponents, matchingPolicy: .nextTime)!
        let secondsUntilNextSelectedTime = nextSetTimeDate.timeIntervalSince(Date()) + 0
        
        return secondsUntilNextSelectedTime
    }
    
    func clearBadge() {
        let application = UIApplication.shared
        DispatchQueue.main.async {
            application.applicationIconBadgeNumber = 0
        }
    }
}

extension AvocadoController {
    
    func saveToPersistentStorage() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(avocados)
            try data.write(to: fileURL(fileName: "AvoKeeprAvocados"))
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
        }
        
        do {
            let data2 = try jsonEncoder.encode(settings)
            try data2.write(to: fileURL(fileName: "AvoKeeprSettings"))
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
        }
    }
    
    func loadFromPersistence() {
        let jsonDecoder = JSONDecoder()
        do {
            let avocadoData = try Data(contentsOf: fileURL(fileName: "AvoKeeprAvocados"))
            let avocados = try jsonDecoder.decode([Avocado].self, from: avocadoData)
            self.avocados = avocados
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
        }
        
        do {
            let settingsData = try Data(contentsOf: fileURL(fileName: "AvoKeeprSettings"))
            let settings = try jsonDecoder.decode([Settings].self, from: settingsData)
            self.settings = settings
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
            
            //sets all properties to base settings if none in storage
            self.settings = [Settings(totalAddedCount: 0, currentCount: 0, eatenCount: 0, trashedCount: 0, currentStreak: 0, longestStreak: 0, avocadoNumber: 0, notificationHour: 19, notificationMinute: 0, notificationsAreEnabledLocally: false, notificationsPrimerPresented: false)]
        }
    }
    
    private func fileURL(fileName: String) -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "\(fileName).json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        
        return documentsDirectoryURL
    }
}
