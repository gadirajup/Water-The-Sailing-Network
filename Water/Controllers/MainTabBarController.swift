//
//  MainTabBarController.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/12/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    
    // MARK:- Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserLoggedIn()
        setupControllers()
    }
    
    fileprivate func setupControllers() {
        // Home Controller
        let homeController = createController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController())
        
        // Search Controller
        let searchController = createController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        // Post Controller
        let postController = createController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: PostController())
        
        // Notification Controller
        let notificationController = createController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        // Profile Controller
        let profileController = createController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: ProfileController())
        
        viewControllers = [homeController, searchController, postController, notificationController, profileController]
        tabBar.tintColor = .black
    }
    
    fileprivate func createController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
    
        let controller = UINavigationController(rootViewController: rootViewController)
        controller.tabBarItem.selectedImage = selectedImage
        controller.tabBarItem.image = unselectedImage
        controller.navigationBar.barStyle = .default
        return controller
    }
    
    fileprivate func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navLoginController = UINavigationController(rootViewController: loginController)
                self.present(navLoginController, animated: true, completion: nil)
            }
        } else {
            print("User Logged In")
        }
    }
}
