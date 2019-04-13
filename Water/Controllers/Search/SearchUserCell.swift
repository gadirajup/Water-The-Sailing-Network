//
//  SearchUserCell.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/13/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {
    
    var user: User? {
        didSet {
            textLabel?.text = user!.username
            detailTextLabel?.text = user!.name
            
            if let imageUrl = URL(string: user!.profileImageUrl) {
                profileImageView.sd_setImage(with: imageUrl, completed: nil)
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 68, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        detailTextLabel?.frame = CGRect(x: 68, y: (detailTextLabel?.frame.origin.y)!, width: frame.width - 108, height: (detailTextLabel?.frame.height)!)
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        detailTextLabel?.textColor = .lightGray
    }
    
    fileprivate func setupView() {
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 48, height: 48))
        profileImageView.centerYInSuperview()
        profileImageView.layer.cornerRadius = 48/2
        profileImageView.clipsToBounds = true
        
        self.textLabel?.text = "Username"
        self.detailTextLabel?.text = "Full Name"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
