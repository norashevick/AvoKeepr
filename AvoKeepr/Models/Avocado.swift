//
//  Avocado.swift
//  AvoKeeperV1
//
//  Created by David on 4/16/20.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

class Avocado: Codable {
    let createdTimestamp = Date()
    let uuid = UUID().uuidString
    var lastMovedTimestamp = Date()
    var due = false
    var table: Int
    var number: Int
    
    init(table: Int, number: Int){
        self.table = table
        self.number = number
    }
}
