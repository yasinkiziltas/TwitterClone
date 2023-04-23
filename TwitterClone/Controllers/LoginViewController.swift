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
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopSpinner()
        
        let tapGestureHandlerRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureHandlerRecognizer)
    }
    
    func startSpinner() {
        mySpinner.startAnimating()
    }
    
    func stopSpinner() {
        mySpinner.hidesWhenStopped = true
        mySpinner.stopAnimating()
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
        startSpinner()
        if txtEmail.text != "" && txtPassword.text != "" {
            Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) {(data, error) in
                if let error = error as NSError? {
                    switch AuthErrorCode.Code(rawValue: error.code) {
                        
                    case .invalidEmail:
                        self.makeAlert(title: "Hata", message: "Geçersiz e-posta adresi.")
                        self.stopSpinner()
                        
                    case .wrongPassword:
                        self.makeAlert(title: "Hata", message: "Parola hatalı!")
                        self.stopSpinner()
                        
                    case .userNotFound:
                        self.makeAlert(title: "Hata", message: "Sistemde böyle bir kullanıcı yok!")
                        self.stopSpinner()
                        
                    default:
                        self.makeAlert(title: "Hata", message: "Giriş işlemi sırasında bir hata oluştu. Parola veya şifre yanlış olabilir.")
                        self.stopSpinner()
                    }
                } else {
                    self.performSegue(withIdentifier: "toHomeFromLogin", sender: self)
                }
            }
        } else {
            self.stopSpinner()
            self.makeAlert(title: "Ops!", message: "Username/Password?")
        }
    }
}
