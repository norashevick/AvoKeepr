//
//  Copy.swift
//  AvoKeeperV1
//
//  Created by David on 5/9/20.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

struct Copy {
    
    struct NotificationsPrimerAlert {
        static let title = "You just added your first avocado!"
        static let body = "On average, an avocado will stay in its section for 2 days before it's ready to be eaten or moved to the next section.\n\nWe will notify you if any avocado isn't moved for 2 or more days to make sure you never lose track.\n\nYou can select your preferred time of day for these notifications in the app settings."
    }
    
    struct TrashedAlert {
        static let title = "Poor avocado :("
        static let body = "Try not to waste any more!"
        static let actionTitle = "OK"
    }
    
    struct DeletedAlert {
        static let title = "Are you sure you want to delete this avocado?"
        static let body = "If it was eaten or thrown away, drag it to those sections. Deleting it will permanently hide it from all stats and records."
    }
    
    struct PreRateAndReviewAlert {
        static let title = ""
        static let body = "If you find this app useful, please rate or review it on the app store. This makes a big difference for the future of the app."
    }
}
