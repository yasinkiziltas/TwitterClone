//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Admin on 16.03.2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }
}
