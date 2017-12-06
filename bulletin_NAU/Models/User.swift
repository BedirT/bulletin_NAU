//
//  User.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/5/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit

class User: NSObject {
    var email : String?
    var name : String?
    var profileImageUrl: String?
    
    init(_ dictionary: [String: AnyObject]) {
        super.init()
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        profileImageUrl = dictionary["profileImageUrl"] as? String
    }
    override init() {
        super.init()
        name = "noName"
        email = "noEmail"
        profileImageUrl = "noImage"
    }
    
}
