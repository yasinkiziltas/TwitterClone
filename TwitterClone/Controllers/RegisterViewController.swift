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
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        stopSpinner()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        self.emailField.keyboardType = .emailAddress
        checkDate()
    }
    
    func checkDate() {
      
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
        let currentDate = Date()
        print(currentDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.birthdayField.text = dateFormatter.string(from:datePicker.date)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let birthday = dateFormatter.date(from: birthdayField.text ?? "") else {
            self.makeAlert(title: "Ops!", message: "Geçersiz format!")
            return
        }

        if birthday >= currentDate {
            self.makeAlert(title: "Ops!", message: "Uyarı: Doğum tarihi bugünden daha ileri bir tarihtir.")
            birthdayField.text = ""
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        var firestoreRef: DocumentReference? = nil
        startSpinner()
        
        if nameField.text != "" && emailField.text != "" && passwordField.text != "" && userNameField.text != "" &&  birthdayField.text != "" {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (authdata, error) in
                if let error = error as NSError? {
                    switch AuthErrorCode.Code(rawValue: error.code) {
                        
                    case .weakPassword:
                        self.makeAlert(title: "Hata", message: "Parola en az 6 karakter olmalıdır..")
                        self.stopSpinner()
                        
                    case .emailAlreadyInUse:
                        self.makeAlert(title: "Hata", message: "Bu mail adresi zaten kullanımda..")
                        self.stopSpinner()
                        
                    case .invalidEmail:
                        self.makeAlert(title: "Hata", message: "Yanlış email formatı!")
                        self.stopSpinner()
                        
                    default:
                        self.makeAlert(title: "Hata", message: "Bir hata oluştu. Lütfen tekrar deneyin.")
                        self.stopSpinner()
                     
                    }
                } else if let authdata = authdata {
                    
                    let fireStoreUser = [
                        "name" : self.nameField.text!,
                        "email" : self.emailField.text!,
                        "userName": self.userNameField.text!,
                        "birthDay" : self.birthdayField.text!,
                        "signUpDate" : FieldValue.serverTimestamp(),
                        "profilePic" : ""] as [String : Any]
                    
                    firestoreRef = firestoreDatabase
                        .collection("Users")
                        .addDocument(data: fireStoreUser, completion: { (error)  in
                             
                            if error != nil {
                                self.stopSpinner()
                                self.makeAlert(title: "Ops!", message: error?.localizedDescription ?? "Error")
                            } else {
                                
                            }
                        })
                    
                    self.performSegue(withIdentifier: "toProfilePicVC", sender: nil)
                    self.stopSpinner()
                    
                } else {
                    print("Bir hata oluştu. Lütfen tekrar deneyin.")
                    self.stopSpinner()
                }
            }
            
        } else {
            self.makeAlert(title: "Error!", message: "Tüm alanlar zorunludur!")
            self.stopSpinner()
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
