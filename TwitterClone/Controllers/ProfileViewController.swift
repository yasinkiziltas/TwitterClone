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

    @IBOutlet weak var circleImg: UIImageView!
    @IBOutlet weak var circleOut: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    let currentUser = Auth.auth().currentUser
    let currentUserEmail = Auth.auth().currentUser?.email
   
    override func viewDidLoad() {
        super.viewDidLoad()
        circleOut?.layer.cornerRadius = (circleOut?.frame.size.width ?? 0.0) / 2
        circleOut?.clipsToBounds = true
        circleOut?.layer.borderWidth = 2.0
        circleOut?.layer.borderColor = UIColor.lightGray.cgColor
        lblEmail.text = currentUserEmail
    }
    
    @IBAction func btnSignOut(_ sender: Any) {
        if currentUser != nil {
            do {
                try Auth.auth().signOut()
                try Auth.auth().useUserAccessGroup(nil)
                self.performSegue(withIdentifier: "toSplashScreen", sender: nil)
            } catch let signOutError as NSError {
                print("Error: %@", signOutError)
            }
        }
    }
}
