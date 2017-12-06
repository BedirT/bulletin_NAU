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
    var id : String?
    
    init(_ dictionary: [String: AnyObject]) {
        super.init()
        name = dictionary["name"] as? String ?? "Name not found"
        id = dictionary["id"] as? String ?? "noID"
        email = dictionary["email"] as? String ?? "Email not found"
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? "Image not found"
    }
    override init() {
        super.init()
        name = "noName"
        email = "noEmail"
        profileImageUrl = "noImage"
    }
    
}
