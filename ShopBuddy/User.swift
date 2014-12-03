//
//  User.swift
//  ShopBuddy
//
//  Created by Darrin Lin on 12/2/14.
//  Copyright (c) 2014 Fancy. All rights reserved.
//

import Foundation

class User {
    
    var username: String
    
    init () {
        username = "guest"
    }
    
    init (newUsername: String) {
        username = newUsername
    }
    
}
