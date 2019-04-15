//
//  ProfileController.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/12/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.

import UIKit
import Firebase

class ProfileController: UICollectionViewController {

    // MARK: - Properties
    private let reuseIdentifier = "Cell"
    private let headerIdentifier = "Header"
    var user: User?
    
    // MARK: - Setup
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If coming from tab bar
        if user == nil {
            setupData()
            setupLogoutButton()
        }
        
        setupView()
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
            self.user = User(uid: uid, dictionary: data)
            self.navigationItem.title = self.user?.username
            
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func setupView() {
        collectionView.backgroundColor = .white
        navigationItem.title = user?.username
        navigationController?.navigationBar.tintColor = .black
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    fileprivate func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    // MARK: - Handlers
    
    @objc fileprivate func handleLogout() {
        let alertController = UIAlertController(title: "Logout", message: "Are You Sure?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                self.present(UINavigationController(rootViewController: loginController), animated: true, completion: nil)
            } catch {
                print("Failed to logout", error.localizedDescription)
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionView

extension ProfileController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        if let user = self.user {
            header.selectedUser = user
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 180)
    }
}
