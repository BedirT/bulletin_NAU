//
//  Message.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/6/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromId: String?
    var text: String?
    var timeStamp: NSNumber?
    var toId: String?
    
    init(dictionary: [String : AnyObject]) {
        super.init()
        fromId = dictionary["fromId"] as? String ?? "No Sender"
        text = dictionary["text"] as? String ?? "No Message"
        timeStamp = dictionary["timeStamp"] as? NSNumber? ?? 0
        toId = dictionary["toId"] as? String ?? "No Receiver"
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
