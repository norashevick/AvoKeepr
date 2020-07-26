//
//  ripeTableViewCell.swift
//  AvoKeeperV1
//
//  Created by David on 5/1/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class RipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var snoozeButton: UIButton!
    
    var avocado: Avocado?
    
    weak var delegate : RipeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func snoozeButtonTapped(_ sender: Any) {
        if let avocado = avocado {
            self.delegate?.presentSnoozeAvocadoAlert(avocado: avocado)
        }
    }
}

protocol RipeTableViewCellDelegate: AnyObject {
    func presentSnoozeAvocadoAlert(avocado: Avocado)
}
