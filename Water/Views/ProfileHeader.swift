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
    
    var user: User? {
        didSet {
            
            configureEditButton()
            
            nameLabel.text = user!.name
            
            if let url = URL(string: user!.profileImageUrl) {
                profileImageView.sd_setImage(with: url, completed: nil)
            }
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
        
        let attributedString = NSMutableAttributedString(
            string: "5\n",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
            ])
        
        attributedString.append(NSAttributedString(
            string: "posts",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ]))
        
        label.attributedText = attributedString
        
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let attributedString = NSMutableAttributedString(
            string: "5\n",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
            ])
        
        attributedString.append(NSAttributedString(
            string: "followers",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ]))
        
        label.attributedText = attributedString
        
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let attributedString = NSMutableAttributedString(
            string: "5\n",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
            ])
        
        attributedString.append(NSAttributedString(
            string: "following",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ]))
        
        label.attributedText = attributedString
        
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
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
    
    fileprivate func setupView() {
        setupProfileImage()
        //setupNameLabel()
        setupStats()
        setupEditButton()
        setupBottom()
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
    
    fileprivate func setupStats() {
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
    
    fileprivate func setupBottom() {
        
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
    
    func configureEditButton() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        if currentUID == user?.uid {
            //edit profile
            editProfileButton.setTitle("Edit Profile", for: .normal)
        } else  {
            // follow
            editProfileButton.setTitle("Follow", for: .normal)
            editProfileButton.setTitleColor(.white, for: .normal)
            editProfileButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
