//
//  AlmostRipeTableViewCell.swift
//  AvoKeeperV1
//
//  Created by David on 4/30/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class AlmostRipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var snoozeButton: UIButton!
    
    var avocado: Avocado?
    
    weak var delegate : AlmostRipeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func snoozeButtonTapped(_ sender: Any) {
        if let avocado = avocado {
            self.delegate?.presentSnoozeAvocadoAlert(avocado: avocado)
        }
    }
}

protocol AlmostRipeTableViewCellDelegate: AnyObject {
    func presentSnoozeAvocadoAlert(avocado: Avocado)
}
