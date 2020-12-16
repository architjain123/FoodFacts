//
//  NutrientViewViewController.swift
//  FoodFacts
//
//  Created by Sathya Sri Pasham on 11/15/20.
//  Copyright © 2020 archit. All rights reserved.
//

import UIKit
import Parse

class NutrientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    var nutrients = [NSDictionary]()
    var foodImage: UIImage!
    var requestType: String!
    var foodSearch: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
                
        if requestType == "identify_fetch" {
            self.imageView.image = foodImage
            self.foodName.isHidden = true
            self.statusLabel.text = "identifying food item..."
            
            // identify and display food type
            APIManager.getFoodFromImage(image: foodImage, onSuccess: { (food) in
                self.foodName.isHidden = false
                self.foodName.text = food.capitalizingFirstLetter()
                self.foodName.font = UIFont.boldSystemFont(ofSize: 28.0)
                print("identification success: \(food)")
                self.statusLabel.text = "fetching nutrition details..."
                
                // get and display nutrition data
                APIManager.getNutritionDetails(foodItem: food, onSuccess: { (nutrients) in
                    self.statusLabel.text = "success :)"
                    self.statusLabel.isHidden = true
                    self.nutrients = nutrients
                    self.tableView.reloadData()
                    print("nutrition success")
                }) { (error) in
                    self.statusLabel.text = "error fetching nutrition :("
                    self.statusLabel.textColor = .red
                    print("nutrition error: \(error)")
                }
            }) { (error) in
                self.statusLabel.text = "identification failed :("
                self.statusLabel.textColor = .red
                print("identification error: \(error)")
            }
        }
        
        if requestType == "search_details" {
            imageWidth.constant = 0
            imageHeight.constant = 0
            view.layoutIfNeeded()
            foodName.text = foodSearch.capitalizingFirstLetter()
            self.statusLabel.text = "fetching nutrition details..."
            APIManager.getNutritionDetails(foodItem: foodSearch, onSuccess: { (nutrients) in
                self.statusLabel.text = "success :)"
                self.statusLabel.isHidden = true
                self.nutrients = nutrients
                self.tableView.reloadData()
                print("nutrition success")
            }) { (error) in
                self.statusLabel.text = "error fetching nutrition :("
                self.statusLabel.textColor = .red
                print("nutrition error: \(error)")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutrients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell", for: indexPath) as! IngredientTableViewCell
        let nutrient = nutrients[indexPath.row]
        cell.ingredientName.text = (nutrient["nutrientName"] as! String)
        let ingredientValue = nutrient["value"] as! Double
        cell.ingredientValue.text = "\(String(format: "%.2f", ingredientValue))"
        let ingredientUnit = nutrient["unitName"] as! String
        cell.ingredientUnit.text = ingredientUnit.lowercased()
        return cell
    }
    
    @available(iOS 13.0, *)
    @IBAction func onFavoriteButton(_ sender: Any) {
        setFavorite(_isFavorited: true)
        
        let fav_item = PFObject(className:"Favorites")
        
        fav_item["name"] = foodName.text!
        fav_item["user"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()!
        let file = PFFileObject(data: imageData)
        fav_item["image"] = file
        
        fav_item.saveInBackground { (success, error) in
            if (success) {
                print("saved")
            } else {
                print("error")
            }
        }
    }
    
    @available(iOS 13.0, *)
    func setFavorite(_isFavorited:Bool) {
        if (_isFavorited){
            favButton.image = UIImage(systemName:"heart.fill")
        } else {
            favButton.image = UIImage(systemName:"heart")
        }
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
