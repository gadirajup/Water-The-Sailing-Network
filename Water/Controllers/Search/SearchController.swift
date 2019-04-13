//
//  SearchController.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/12/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UITableViewController {
    
    // MARK: - Properties
    
    var reuseIdentifier = "cell"
    var users = [User]()

    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupView()
        setupTableView()
    }
    
    fileprivate func setupData() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Failed to get users", error.localizedDescription)
            }
            
            guard let data = snapshot?.documents else { return }
            data.forEach({ (document) in
                let user = User(document: document)
                self.users.append(user)
                
                self.tableView.reloadData()
            })
        }
    }
    
    fileprivate func setupView() {
        navigationItem.title = "Search"
    }
    
    fileprivate func setupTableView() {
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorInset = .init(top: 0, left: 64, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Handlers
}

// MARK: - Table View

extension SearchController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
    }
}
