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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        stopSpinner()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        self.emailField.keyboardType = .emailAddress
    }
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
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
        startSpinner()
        
        if nameField.text != "" && emailField.text != "" && passwordField.text != "" && birthdayField.text != "" {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (authdata, error) in
                if error != nil {
                    self.stopSpinner()
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    self.stopSpinner()
                    self.performSegue(withIdentifier: "toProfilePicVC", sender: nil)
                }
            }
            
        } else {
            self.stopSpinner()
            self.makeAlert(title: "Error!", message: "Mail or password must a value!")
        }
            
            let firestoreDatabase = Firestore.firestore()
            var firestoreRef: DocumentReference? = nil
            let fireStoreUser = ["name" : nameField.text!, "email" : emailField.text!, "birthDay" : birthdayField.text!, "signUpDate" : FieldValue.serverTimestamp(), "profilePic" : ""] as [String : Any]
            
            firestoreRef = firestoreDatabase
                .collection("Users")
                .addDocument(data: fireStoreUser, completion: { (error)  in
                     
                    if error != nil {
                        self.stopSpinner()
                        self.makeAlert(title: "Ops!", message: error?.localizedDescription ?? "Error")
                    } else {
                        
                    }
                })
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
