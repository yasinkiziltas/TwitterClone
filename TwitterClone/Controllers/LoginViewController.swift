//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Admin on 16.03.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureHandlerRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureHandlerRecognizer)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        if txtEmail.text != "" && txtPassword.text != "" {
            Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) {(data, error) in
                if error != nil {
                    self.makeAlert(title: "Ops!", message: error?.localizedDescription ?? "")
                } else {
                    self.performSegue(withIdentifier: "toHomeFromLogin", sender: self)
                }
            }
        } else {
            self.makeAlert(title: "Ops!", message: "Username/Password?")
        }
    }
}
