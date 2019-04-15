//
//  ProfileHeader.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/12/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class ProfileHeader: UICollectionViewCell {
    
    // MARK: - Properties
    let currentUser = Auth.auth().currentUser?.uid
    var selectedUser: User? {
        didSet {
            // Check if current user already follows selected user and change follow button accordingly
            checkIfFollows()
            
            // Update user data (followers, following, posts)
            updateSelectedUserData()

            // Update User Information (name label, profile image)
            updateUserInfo()
        }
    }
    
    // MARK: - UI Elements
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.constrainWidth(constant: 90)
        iv.constrainHeight(constant: 90)
        iv.layer.cornerRadius = 45
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Full Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setAttributedText(with: "0", and: "posts")
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setAttributedText(with: "0", and: "followers")
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setAttributedText(with: "0", and: "following")
        return label
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleEditFollow), for: .touchUpInside)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        setupProfileImage()
        setupStatsUI()
        setupEditButton()
        setupBottomControls()
    }
    
    fileprivate func setupProfileImage() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
    }
    
    fileprivate func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true
    }
    
    fileprivate func setupStatsUI() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .yellow
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        stackView.constrainHeight(constant: 80)
    }
    
    fileprivate func setupEditButton() {
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor, leading: postsLabel.leadingAnchor, bottom: nil, trailing: followingLabel.trailingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 12))
        editProfileButton.constrainHeight(constant: 30)
    }
    
    fileprivate func setupBottomControls() {
        
        let botDividerView = UIView()
        botDividerView.backgroundColor = .lightGray
        
        addSubview(botDividerView)
        botDividerView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        botDividerView.constrainHeight(constant: 0.5)
        
        let stackView = UIStackView(arrangedSubviews: [listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: botDividerView.topAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 8, right: 0))
        stackView.constrainHeight(constant: 30)
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        addSubview(topDividerView)
        topDividerView.anchor(top: nil, leading: leadingAnchor, bottom: stackView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
        topDividerView.constrainHeight(constant: 0.5)
        
    }
    
    // MARK: - Update Functions
    
    func updateEditButton(isFollowing: Bool) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        if currentUID == selectedUser?.uid {
            //edit profile
            editProfileButton.setTitle("Edit Profile", for: .normal)
        } else  {
            if isFollowing == true {
                // follow
                editProfileButton.setTitle("Following", for: .normal)
                editProfileButton.setTitleColor(.white, for: .normal)
                editProfileButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            } else {
                // unfollow
                editProfileButton.setTitle("Follow", for: .normal)
                editProfileButton.setTitleColor(.white, for: .normal)
                editProfileButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            }

        }
    }
    
    func updateUserInfo() {
        nameLabel.text = selectedUser!.name
        
        if let url = URL(string: selectedUser!.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    func updateSelectedUserData() {
        
        // Update Followers Text Label
        Fire.fire.getFollowersForUser(withUID: selectedUser!.uid) { [weak self] (followers) in
            self?.followersLabel.setAttributedText(with: String(followers.count), and: "followers")
        }
        
        // Update Followers Text Label
        Fire.fire.getFollowingForUser(withUID: selectedUser!.uid) { [weak self] (following) in
            self?.followingLabel.setAttributedText(with: String(following.count), and: "following")
        }
    }
    
    // MARK: - Handle Functions
    
    @objc fileprivate func handleEditFollow() {
        if editProfileButton.title(for: .normal) == "Edit Profile" {
            print("Edit")
        } else if editProfileButton.title(for: .normal) == "Follow" {
            editProfileButton.setTitle("Following", for: .normal)
            handleFollow()
        } else if editProfileButton.title(for: .normal) == "Following" {
            editProfileButton.setTitle("Follow", for: .normal)
            handleUnfollow()
        }
    }
    
    fileprivate func handleFollow() {
        Fire.fire.follow(selectedUser: selectedUser!, for: currentUser!)
    }
    
    fileprivate func handleUnfollow() {
        Fire.fire.unfollow(selectedUser: selectedUser!, for: currentUser!)
    }
    
    // MARK: - Logic Functions
    
    fileprivate func checkIfFollows() {
        Fire.fire.checkIf(currentUserUID: currentUser!, follows: selectedUser!) { (isFollowing) in
            self.updateEditButton(isFollowing: isFollowing)
        }
    }
}
