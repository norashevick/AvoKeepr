//
//  SettingsTableViewController.swift
//  SettingsPrototype
//
//  Created by David on 4/9/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var datePickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePickerHidden = true
        matchToggleWithAuthorizationStatusAndControllerState()
        matchTimePickerAndLabelWithControllerTime()
        tableView.reloadData()
    }
    
    func matchTimePickerAndLabelWithControllerTime() {
        
        let calendar = Calendar.current
        let dateComponents = DateComponents(hour: AvocadoController.shared.settings[0].notificationHour, minute: AvocadoController.shared.settings[0].notificationMinute)
        let date = calendar.date(from: dateComponents)!
        timePicker.setDate(date, animated: false)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timeString = dateFormatter.string(from: timePicker.date)
        timeLabel.text = timeString
    }
    
    func matchToggleWithAuthorizationStatusAndControllerState() {
        
        if AvocadoController.shared.settings[0].notificationsAreEnabledLocally == false {
            notificationsSwitch.isOn = false
            return
        }
        
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined || settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    self.notificationsSwitch.isOn = false
                }
            }  else if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    self.notificationsSwitch.isOn = true
                }
            }
        })
    }
    
    @IBAction func timeChanged(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timeString = dateFormatter.string(from: timePicker.date)
        timeLabel.text = timeString
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        
        let date = timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        
        AvocadoController.shared.setNotificationTime(hour: hour, minute: minute)
        AvocadoController.shared.scheduleUpcomingNotification()
    }
    
    private func toggleDatePicker() {
        
        if datePickerHidden {
            datePickerHidden = !datePickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
        } else {
            datePickerHidden = !datePickerHidden
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if datePickerHidden && indexPath.row == 2 {
            return 0
        } else if !datePickerHidden && indexPath.row == 2 {
            return 180
        } else {
            return 43.5
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            toggleDatePicker()
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            ()
        }
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.requestInitialNotificationAuthorizationNoPrimer()
            } else if settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    self.presentNavigateToAppSettingsAlert()
                    self.notificationsSwitch.isOn = false
                }
                
            } else if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    AvocadoController.shared.notificationsSwitchToggled()
                }
            }
        })
    }
    
    func presentNavigateToAppSettingsAlert() {
        
        let title = "Enable Notifications"
        let message = "You previosly denied the app access to send you notifications.\n\nPlease navigate to your phones notifications settings to enable this app to send reminders."
        let actionTitle = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestInitialNotificationAuthorizationNoPrimer() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                AvocadoController.shared.setNotificationsAreEnabledLocally(to: true)
                
            } else if error != nil {
                print("error occurred. \(error!)")
            } else {
                AvocadoController.shared.setNotificationsAreEnabledLocally(to: false)
                DispatchQueue.main.async {
                    self.notificationsSwitch.isOn = false
                }
            }})
    }
}
