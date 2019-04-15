//
//  User.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/13/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import Foundation
import Firebase

class User {
    var username: String!
    var name: String!
    var profileImageUrl: String!
    var uid: String!
    var isFollowed = false
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
            self.profileImageUrl = profileImageUrl
        }
    }
    
    init(document: QueryDocumentSnapshot) {
        self.uid = document.documentID
        
        if let username = document["username"] as? String {
            self.username = username
        }
        
        if let name = document["name"] as? String {
            self.name = name
        }
        
        if let profileImageUrl = document["profileImageUrl"] as? String {
            self.profileImageUrl = profileImageUrl
        }
    }
}
