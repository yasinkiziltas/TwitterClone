//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Admin on 23.03.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnSignOut(_ sender: Any) {
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil {
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "toSplashScreen", sender: nil)
            } catch {
                print("Error")
            }
        }
    }
}
