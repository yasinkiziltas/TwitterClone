//
//  AddProfilePictureViewController.swift
//  TwitterClone
//
//  Created by Admin on 17.03.2023.
//

import UIKit
import Firebase

class AddProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopSpinner()
        
        btnNext.layer.cornerRadius = 25
        btnNext.layer.borderWidth = 0.1
        btnNext.layer.backgroundColor = UIColor.lightGray.cgColor
        btnNext.layer.borderColor = UIColor.gray.cgColor
        
        imgView.isUserInteractionEnabled = true
        
        let imgTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImg))
        imgView.addGestureRecognizer(imgTapGestureRecognizer)
        
        //getUsers()
    }
    
    func startSpinner() {
        mySpinner.startAnimating()
    }
    
    func stopSpinner() {
        mySpinner.hidesWhenStopped = true
        mySpinner.stopAnimating()
    }
    
    @objc func chooseImg() {
        startSpinner()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        stopSpinner()
        imgView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func goNext(_ sender: Any) {
        startSpinner()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = imgView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    self.stopSpinner()
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    
                    imageReferance.downloadURL{ (url, error) in
                        if error == nil {
                            let imageURL = url?.absoluteString
                            
                            //Database
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreRef: DocumentReference? = nil
                            let firestorePost = ["imageURL" : imageURL!, "email": Auth.auth().currentUser!.email, "addedDate": FieldValue.serverTimestamp()] as [String: Any]
                            
                            firestoreRef = firestoreDatabase.collection("UserProfileImages").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.stopSpinner()
                                    self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    self.performSegue(withIdentifier: "toHomeFromProfilePic", sender: nil)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String ) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okBtn)
        self.present(alert, animated: true)
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        performSegue(withIdentifier: "toHomeFromProfilePic", sender: nil)
    }
}
