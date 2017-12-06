//
//  Message.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/6/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit

class Message: NSObject {

    var fromID: String?
    var text: String?
    var timeStamp: Int?
    var toID: String?
    
    init(dictionary: [String : AnyObject]) {
        super.init()
        fromID = dictionary["fromId"] as? String ?? "No Sender"
        text = dictionary["text"] as? String ?? "No Message"
        timeStamp = dictionary["timeStamp"] as? Int? ?? 0
        toID = dictionary["toId"] as? String ?? "No Receiver"
    }
    
}
