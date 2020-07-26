//
//  Haptics.swift
//  AvoKeeperV1
//
//  Created by David on 5/9/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

struct Haptics {
    
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
