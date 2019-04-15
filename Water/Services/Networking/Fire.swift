//
//  Firebase.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/15/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import Foundation
import Firebase

class Fire {
    static let fire = Fire()
    
    func getFollowersForUser(withUID uid: String, completion: @escaping ([String]) -> ()) {
        USERS_FOLLOWERS_REF.document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Error getting users followers", error.localizedDescription)
                return
            }
            
            guard let followers = snapshot?.data() else { return }
            completion(Array(followers.keys))
        }
    }
    
    func getFollowingForUser(withUID uid: String, completion: @escaping ([String]) -> ()) {
        USERS_FOLLOWING_REF.document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Error getting users followers", error.localizedDescription)
                return
            }
            
            guard let following = snapshot?.data() else { return }
            completion(Array(following.keys))
        }
    }
    
    func checkIf(currentUserUID: String, follows selectedUser: User, completion: @escaping (Bool) -> ()) {
        let currentUID = currentUserUID
        guard let selectedUID = selectedUser.uid else { return }
        
        USERS_FOLLOWING_REF.document(currentUID).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to get users following collection", error.localizedDescription)
                return
            }
            
            guard let currentUserFollowing = snapshot?.data() else { return }
            if currentUserFollowing.keys.contains(selectedUID) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
