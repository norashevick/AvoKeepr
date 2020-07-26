//
//  HomeViewController.swift
//  SettingsPrototype
//
//  Created by David on 3/29/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import MobileCoreServices

class HomeViewController: UIViewController {
    
    @IBOutlet weak var notRipeTableView: UITableView!
    @IBOutlet weak var almostRipeTableView: UITableView!
    @IBOutlet weak var ripeTableView: UITableView!
    @IBOutlet var allTableViews: [UITableView]!
    
    @IBOutlet weak var notRipeView: UIView!
    @IBOutlet weak var almostRipeView: UIView!
    @IBOutlet weak var ripeView: UIView!
    @IBOutlet var allSectionViews: [UIView]!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageIconImageView: UIImageView!
    
    @IBOutlet weak var eatenCollectionView: UICollectionView!
    @IBOutlet weak var trashedCollectionView: UICollectionView!
    @IBOutlet weak var deleteCollectionView: UICollectionView!
    
    @IBOutlet weak var addAvocadoButton: UIButton!
    
    let addAvocadoAlert = AddAvocadoAlertViewController()
    
    let cardPadding: CGFloat = 8
    let cardRadius: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViewsAndReminder()
    }
    
    func setUpViews() {
        
        for tableView in allTableViews {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.dragInteractionEnabled = true
            tableView.dragDelegate = self
            tableView.dropDelegate = self
        }
        
        let shadowRadius: CGFloat = 2.5
        let shadowOpacity: Float = 0.55
        
        for view in allSectionViews {
            view.layer.cornerRadius = cardPadding
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = shadowOpacity
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = shadowRadius
        }
        
        eatenCollectionView.dropDelegate = self
        trashedCollectionView.dropDelegate = self
        deleteCollectionView.dropDelegate = self
        deleteCollectionView.layer.cornerRadius = 4
        deleteCollectionView.isHidden = true
        
        addAvocadoButton.layer.borderWidth = 3
        addAvocadoButton.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        addAvocadoButton.layer.cornerRadius = 8
        addAvocadoButton.setTitleColor(.black, for: .normal)
        
        updateMessageLabelAndIcon()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onAvocadoAdded(_:)), name: Notification.Name("AvocadosAdded"), object: nil)
    }
    
    func updateViewsAndReminder(){
        
        AvocadoController.shared.checkIfDueAndFlipAttribute()
        
        ripeTableView.reloadData()
        almostRipeTableView.reloadData()
        notRipeTableView.reloadData()
        
        updateMessageLabelAndIcon()
        
        AvocadoController.shared.scheduleUpcomingNotification()
    }
    
    func updateMessageLabelAndIcon() {
        
        messageLabel.text = AvocadoController.shared.formulateMessageLabel()
        
        if let messageIconImage = AvocadoController.shared.returnMessageIconImage() {
            messageIconImageView.isHidden = false
            messageIconImageView.image = messageIconImage
        } else {
            messageIconImageView.isHidden = true
        }
    }
    
    @objc func onAvocadoAdded(_ notification: Notification) {
        
        updateViewsAndReminder()
        Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(HomeViewController.presentNotificationsPrimerAlert), userInfo: nil, repeats: false)
    }
    
    @IBAction func addAvocadoButtonTapped(_ sender: Any) {
        present(AvocadoController.shared.presentAddAvocadoAlert(), animated: true)
    }
    
    @objc func presentNotificationsPrimerAlert() {
        
        if AvocadoController.shared.settings[0].notificationsPrimerPresented == false {
            
            let notificationsPrimerAlert = UIAlertController(title: Copy.NotificationsPrimerAlert.title, message: Copy.NotificationsPrimerAlert.body, preferredStyle: .alert)
            notificationsPrimerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.requestNotificationsAuthorization()
            }))
            self.present(notificationsPrimerAlert, animated: true, completion: nil)
            
            AvocadoController.shared.settings[0].notificationsPrimerPresented = true
        }
    }
    
    func requestNotificationsAuthorization() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                AvocadoController.shared.setNotificationsAreEnabledLocally(to: true)
                AvocadoController.shared.scheduleUpcomingNotification()
            } else if error != nil {
                print("error occurred. \(error!)")
            } else {
                print("permission not granted or previosly denied")
            }
        })
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.notRipeTableView {
            return AvocadoController.shared.avocados.filter({$0.table == 0}).count
        } else if tableView == self.almostRipeTableView {
            return AvocadoController.shared.avocados.filter({$0.table == 1}).count
        } else if tableView == self.ripeTableView {
            return AvocadoController.shared.avocados.filter({$0.table == 2}).count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cardPadding
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? cardPadding : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let avocado: Avocado
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        
        if tableView == self.notRipeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notRipeCell", for: indexPath) as! NotRipeTableViewCell
            
            let notRipeAvocados = AvocadoController.shared.avocados.filter({$0.table == 0})
            avocado = notRipeAvocados[indexPath.section]
            
            cell.avocado = avocado
            cell.delegate = self
            cell.snoozeButton.isHidden = avocado.due ? false : true
            cell.dateAddedLabel?.text = "added\n\(dateFormatter.string(from: avocado.createdTimestamp))"
            cell.layer.cornerRadius = cardRadius
            
            return cell
            
        } else if tableView == self.almostRipeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "almostRipeCell", for: indexPath) as! AlmostRipeTableViewCell
            
            let almostRipeAvocados = AvocadoController.shared.avocados.filter({$0.table == 1})
            avocado = almostRipeAvocados[indexPath.section]
            
            cell.avocado = avocado
            cell.delegate = self
            cell.snoozeButton.isHidden = avocado.due ? false : true
            cell.dateAddedLabel?.text = "added\n\(dateFormatter.string(from: avocado.createdTimestamp))"
            cell.layer.cornerRadius = cardRadius
            
            return cell
            
        } else if tableView == self.ripeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ripeCell", for: indexPath) as! RipeTableViewCell
            
            let ripeAvocados = AvocadoController.shared.avocados.filter({$0.table == 2})
            avocado = ripeAvocados[indexPath.section]
            
            cell.avocado = avocado
            cell.delegate = self
            cell.snoozeButton.isHidden = avocado.due ? false : true
            cell.dateAddedLabel?.text = "added\n\(dateFormatter.string(from: avocado.createdTimestamp))"
            cell.layer.cornerRadius = cardRadius
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
}

extension HomeViewController: NotRipeTableViewCellDelegate, AlmostRipeTableViewCellDelegate, RipeTableViewCellDelegate {
    
    func presentSnoozeAvocadoAlert(avocado: Avocado) {
        
        let title = "Snooze Avocado?"
        let message = "How long would you like to snooze this avocado for before it becomes due again?"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "One day", style: .default, handler: { (_) in
            
            AvocadoController.shared.snoozeAvocado(uuid: avocado.uuid, days: 1)
            self.updateViewsAndReminder()
        }))
        alert.addAction(UIAlertAction(title: "Two days", style: .default, handler: { (_) in
            
            AvocadoController.shared.snoozeAvocado(uuid: avocado.uuid, days: 2)
            self.updateViewsAndReminder()
        }))
        alert.addAction(UIAlertAction(title: "Three days", style: .default, handler: { (_) in
            
            AvocadoController.shared.snoozeAvocado(uuid: avocado.uuid, days: 3)
            self.updateViewsAndReminder()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let tableViewArray: [Avocado]
        
        if tableView == self.notRipeTableView {
            tableViewArray = AvocadoController.shared.avocados.filter({$0.table == 0})
        } else if tableView == self.almostRipeTableView {
            tableViewArray = AvocadoController.shared.avocados.filter({$0.table == 1})
        } else if tableView == self.ripeTableView {
            tableViewArray = AvocadoController.shared.avocados.filter({$0.table == 2})
        } else {
            tableViewArray = []
        }
        
        guard let itemData = tableViewArray[indexPath.section].uuid.data(using: .utf8) else {
            return []
        }
        
        let itemProvider = NSItemProvider(item: itemData as NSData, typeIdentifier: kUTTypePlainText as String)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        Haptics.light()
        
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        deleteCollectionView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        deleteCollectionView.isHidden = true
    }
}

extension HomeViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        Haptics.medium()
        
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String])  {
            coordinator.session.loadObjects(ofClass: NSString.self) { (items) in
                guard let id = items.first as? String else {
                    return
                }
                
                if tableView == self.notRipeTableView {
                    AvocadoController.shared.moveToNotRipe(uuid: id)
                } else if tableView == self.almostRipeTableView {
                    AvocadoController.shared.moveToAlmostRipe(uuid: id)
                } else if tableView == self.ripeTableView {
                    AvocadoController.shared.moveToRipe(uuid: id)
                }
                self.updateViewsAndReminder()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String])  {
            
            Haptics.medium()
            
            coordinator.session.loadObjects(ofClass: NSString.self) { (items) in
                guard let id = items.first as? String else {
                    return
                }
                
                if collectionView == self.eatenCollectionView {
                    AvocadoController.shared.moveToEaten(uuid: id)
                    self.presentEatenAlert()
                } else if collectionView == self.trashedCollectionView {
                    AvocadoController.shared.moveToTrashed(uuid: id)
                    self.presentTrashedAlert()
                } else if collectionView == self.deleteCollectionView {
                    self.presentDeleteAlert(for: id)
                } else {
                    return
                }
                
                self.updateViewsAndReminder()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        Haptics.light()
    }
    
    func presentEatenAlert() {
        
        let title: String
        let message: String
        
        if AvocadoController.shared.settings[0].eatenCount == 1 {
            title = "Your first avocado has been eaten!"
            message = "Great work! Isn't tracking your avocados with Avo Keepr easy?\n\nYou can check out how you're doing in the stats section."
        } else if AvocadoController.shared.settings[0].currentStreak > 1 {
            title = "Eaten!"
            message = "Your current eaten streak without trashing an avocado is \(AvocadoController.shared.settings[0].currentStreak).\n\nKeep it up."
        } else {
            title = "Eaten!"
            message = "You have eaten \(AvocadoController.shared.settings[0].eatenCount) avocados with Avo Keepr."
        }
        
        let eatenAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        eatenAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(eatenAlert, animated: true, completion: nil)
    }
    
    func presentTrashedAlert() {
        
        let trashedAlert = UIAlertController(title: Copy.TrashedAlert.title, message: Copy.TrashedAlert.body, preferredStyle: .alert)
        trashedAlert.addAction(UIAlertAction(title: Copy.TrashedAlert.actionTitle, style: .default, handler: nil))
        self.present(trashedAlert, animated: true, completion: nil)
    }
    
    func presentDeleteAlert(for id: String) {
        
        let deletedAlert = UIAlertController(title: Copy.DeletedAlert.title, message: Copy.DeletedAlert.body, preferredStyle: .alert)
        deletedAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        deletedAlert.addAction(UIAlertAction(title: "Delete it", style: .cancel, handler: { (_) in
            AvocadoController.shared.delete(uuid: id)
            self.updateViewsAndReminder()
        }))
        self.present(deletedAlert, animated: true, completion: nil)
    }
}
