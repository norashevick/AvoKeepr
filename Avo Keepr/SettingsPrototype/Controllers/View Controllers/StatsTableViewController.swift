//
//  StatsTableViewController.swift
//  SettingsPrototype
//
//  Created by David on 3/30/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class StatsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return StatsSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = StatsSection(rawValue: section) else { return nil }
        
        switch section {
        case .generalStats: return nil
        case .streaks: return "Streaks"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = StatsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .generalStats: return GeneralStats.allCases.count
        case .streaks: return Streaks.allCases.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statCell", for: indexPath)
        guard let section = StatsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .generalStats:
            let general = GeneralStats(rawValue: indexPath.row)
            cell.textLabel?.text = general?.description
            cell.detailTextLabel?.text = general?.stat
            
        case .streaks:
            let streak = Streaks(rawValue: indexPath.row)
            cell.textLabel?.text = streak?.description
            cell.detailTextLabel?.text = streak?.stat
        }
        return cell
    }
}
