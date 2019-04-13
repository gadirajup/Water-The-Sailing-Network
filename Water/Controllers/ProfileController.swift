//
//  ProfileController.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/12/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class ProfileController: UICollectionViewController {

    // MARK: - Properties
    
    
    // MARK: - Setup
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        
        setupView()
        setupLogoutButton()
        setupCollectionView()
    }
    
    fileprivate func setupData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Unable to get data", error.localizedDescription)
                return
            }

            guard let data = snapshot?.data() else { return }
            guard let username = data["username"] as? String else { return }
            self.navigationItem.title = username
        }
    }
    
    fileprivate func setupView() {
        collectionView.backgroundColor = .orange
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    fileprivate func setupLogoutButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    // MARK: - Handlers
    
    @objc fileprivate func handleLogout() {
        let alertController = UIAlertController(title: "Logout", message: "Are You Sure?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                self.present(loginController, animated: true, completion: nil)
            } catch {
                print("Failed to logout", error.localizedDescription)
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionView

extension ProfileController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        
        return cell
    }
}
