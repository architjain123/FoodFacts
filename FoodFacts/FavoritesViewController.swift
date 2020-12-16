//
//  FavoritesViewController.swift
//  FoodFacts
//
//  Created by Haasi  on 11/12/20.
//  Copyright © 2020 archit. All rights reserved.
//

import UIKit
import Parse
import SideMenu

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var menu: SideMenuNavigationController?
    var fav_items = [PFObject]()
    var selectedPost: PFObject!
    var food: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    @IBAction func onTapMenu(){
        present(menu!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fav_items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell") as! FavoritesCell
        let post = fav_items[indexPath.row]
        cell.foodLabel.text = (post["name"] as! String)

        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!

        cell.photoView.af.setImage(withURL: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = fav_items[indexPath.row]
        self.food = (post["name"] as! String)
        performSegue(withIdentifier: "favGetDetails", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getFavData()
    }
    
    func getFavData(){
        let query = PFQuery(className:"Favorites")
        query.includeKey("user")
        query.limit = 20
        
        query.findObjectsInBackground { (fav_items, error) in
            if (fav_items != nil) {
                self.fav_items = fav_items!
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func onDeleteButton(_ sender: UIButton) {
        let buttonPostion = sender.convert(sender.bounds.origin, to: tableView)

        if let indexPath = tableView.indexPathForRow(at: buttonPostion) {
            let post = fav_items[indexPath.row]
            let query = PFQuery(className:"Favorites")
            query.whereKey("name", equalTo: (post["name"] as! String))
            query.getFirstObjectInBackground(block: {(parseObject: PFObject?, error: Error?) -> Void in
                if error != nil {
                    print(error!)
                } else if parseObject != nil {
                    parseObject?.deleteInBackground()
                    print("item deleted")
                    DispatchQueue.main.async{
                        self.getFavData()
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "favGetDetails"){
            let destination = segue.destination as! NutrientViewController
            destination.foodSearch = self.food
            destination.requestType = "search_details"
        }
    }
}
