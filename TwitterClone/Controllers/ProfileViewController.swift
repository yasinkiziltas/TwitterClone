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

    
    @IBOutlet weak var lblEmail: UILabel!
    let currentUser = Auth.auth().currentUser
    let currentUserEmail = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblEmail.text = currentUserEmail
    }
    
    @IBAction func btnSignOut(_ sender: Any) {
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
