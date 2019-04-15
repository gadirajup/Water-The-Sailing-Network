//
//  Constants.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/15/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import Foundation
import Firebase

let USERS_REF = Firestore.firestore().collection("users")
let USERS_FOLLOWING_REF = Firestore.firestore().collection("users-following")
let USERS_FOLLOWERS_REF = Firestore.firestore().collection("users-followers")

