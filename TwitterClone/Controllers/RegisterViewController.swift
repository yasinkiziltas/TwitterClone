//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Admin on 16.03.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        self.emailField.keyboardType = .emailAddress
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func createToolBar() -> UIToolbar {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done btn
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        birthdayField.inputView = datePicker
        birthdayField.inputAccessoryView = createToolBar()
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.birthdayField.text = dateFormatter.string(from:datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toProfilePicVC", sender: nil)
                }
            }
        } else {
            self.makeAlert(title: "Error!", message: "Mail or password must a value!")
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
