//
//  MenuTableViewController.swift
//  FoodFacts
//
//  Created by Archit Jain on 10/25/20.
//  Copyright © 2020 archit. All rights reserved.
//

import UIKit
import Parse

class MenuTableViewController: UITableViewController {

    var items = ["Home", "Favorites", "Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemOrange
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  "menuCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .systemOrange
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        switch(indexPath.row){
        case 0:
            let homeVC = storyBoard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
            self.navigationController?.pushViewController(homeVC.viewControllers.first!, animated: false)
            break
            
        case 1:
            let favVC = storyBoard.instantiateViewController(withIdentifier: "FavNavigationController") as! UINavigationController
            self.navigationController?.pushViewController(favVC.viewControllers.first!, animated: false)
            break
            
        case 2:
            print("Logout")
            PFUser.logOut()
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
            UIApplication.shared.keyWindow?.rootViewController = loginVC
            break
            
        default:
            break
        }
    }
}
