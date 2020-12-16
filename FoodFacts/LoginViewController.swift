//
//  LoginViewController.swift
//  FoodFacts
//
//  Created by Archit Jain on 10/24/20.
//  Copyright © 2020 archit. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        usernameField.attributedPlaceholder =
        NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordField.attributedPlaceholder =
        NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else{
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
