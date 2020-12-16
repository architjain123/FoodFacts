//
//  MainViewController.swift
//  FoodFacts
//
//  Created by Archit Jain on 10/24/20.
//  Copyright © 2020 archit. All rights reserved.
//

import UIKit
import Parse
import SideMenu
import AlamofireImage

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate {
    
    var menu: SideMenuNavigationController?
    var foodImage: UIImage!
    var food: String!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.isHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        searchBar.isHidden = false
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.food = searchBar.text!
        performSegue(withIdentifier: "searchDetails", sender: nil)
    }
    
    @IBAction func onTapOutside(_ sender: Any) {
        view.endEditing(true)
        searchBar.isHidden = true
    }
    
    @IBAction func onTapMenu(){
        present(menu!, animated: true)
    }
    
    @IBAction func onScanButton(_ sender: UITapGestureRecognizer) {
        print("pressed scan button")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 400, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        self.foodImage = scaledImage
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "foodIdentifier", sender: nil)
    }
        
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "foodIdentifier"){
            let destination = segue.destination as! NutrientViewController
            destination.foodImage = self.foodImage
            destination.requestType = "identify_fetch"
        }
        if(segue.identifier == "searchDetails"){
            let destination = segue.destination as! NutrientViewController
            destination.foodSearch = self.food
            destination.requestType = "search_details"
        }
    }
}
