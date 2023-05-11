//
//  AddTweetViewController.swift
//  TwitterClone
//
//  Created by Admin on 28.03.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class AddTweetViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var btnAccesibility: UIButton!
    @IBOutlet weak var tweetArea: UITextView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let placeholderLabel = UILabel()
    let currentUser = Auth.auth().currentUser?.uid
    let cUser = Auth.auth().currentUser
    var currentUserName = ""
    var currentUserNickName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        tweetArea.delegate = self
        view.addSubview(tweetArea)
        
        btnAccesibility.backgroundColor = .clear
        btnAccesibility.layer.cornerRadius = 15
        
        
        imgView.isUserInteractionEnabled = true
        stopSpinner()
        
        placeholderLabel.text = "What happened?"
        placeholderLabel.font = tweetArea.font // metin giriş kutusuyla aynı font
        placeholderLabel.sizeToFit()
        tweetArea.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: tweetArea.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tweetArea.text.isEmpty
    }
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
    }
    
    func textViewDidChange(_ textView: UITextView) {
            placeholderLabel.isHidden = !tweetArea.text.isEmpty
        }
  
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true ,completion: nil)
    }
    
    @IBAction func btnAccessibility(_ sender: Any) {
        makeAlert(titleInput: "OK", messageInput: "Building..")
    }
    
    @IBAction func btnReply(_ sender: Any) {
        makeAlert(titleInput: "OK", messageInput: "Building..")
    }
    
    func getUserInfo() {
        let db = Firestore.firestore()
        let usersRef = db.collection("Users")
        let tweetRef = db.collection("Tweets")
        
        usersRef.getDocuments{(querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    let userEmail = document.get("email") as! String
                    
                    if self.cUser?.email == userEmail {
                        let cUserName = document.get("name") as! String
                        let cUserNickName = document.get("userName") as! String
                        self.currentUserNickName = cUserNickName
                        self.currentUserName = cUserName
                    }
                }
            }
        }
    }
    
    @IBAction func btnTweet(_ sender: Any) {
        startSpinner()
        
        if tweetArea.text?.isEmpty ?? true {
            makeAlert(titleInput: "OK", messageInput: "You must enter a tweet!")
        } else {
        if imgView.image == nil {
            let firestoreDB = Firestore.firestore()
            var firestoreRf: DocumentReference? = nil
            
           
            let firestorePostWithoutImg = ["imageURL" : "", "postedByName" : currentUserName, "postedByEmail": Auth.auth().currentUser!.email, "postedByNickName": currentUserNickName, "tweetContent": self.tweetArea.text!, "tweetDate": FieldValue.serverTimestamp(), "likes" : 0] as [String: Any]
            
            firestoreRf = firestoreDB.collection("Tweets").addDocument(data: firestorePostWithoutImg, completion: { (error) in
                if error != nil {
                    self.stopSpinner()
                    self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    let existingCollectionRef = firestoreDB.collection("Tweets")
                    let existingDocRef = existingCollectionRef.document(firestoreRf?.documentID ?? "")

                    let newSubcollectionRef = existingDocRef.collection("tweetLikes")
                    let newSubdocumentRef = newSubcollectionRef.document()

                    newSubdocumentRef.setData([
                        "userID": "",
                        "timestamp": ""
                    ])
                    self.dismiss(animated: true, completion: nil)
                    self.stopSpinner()
                }
            })
        } else {
            let storage =  Storage.storage()
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
                                let firestorePost = ["imageURL" : imageURL!, "postedByName": self.currentUserName, "postedByEmail": Auth.auth().currentUser!.email, "postedByNickName": self.currentUserNickName, "tweetContent": self.tweetArea.text!, "tweetDate": FieldValue.serverTimestamp(), "likes" : 0] as [String: Any]
                                
                                firestoreRef = firestoreDatabase.collection("Tweets").addDocument(data: firestorePost, completion: { (error) in
                                    if error != nil {
                                        self.stopSpinner()
                                        self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                                    } else {
                                        let existingCollectionRef = firestoreDatabase.collection("Tweets")
                                        let existingDocRef = existingCollectionRef.document(firestoreRef?.documentID ?? "")

                                        let newSubcollectionRef = existingDocRef.collection("tweetLikes")
                                        let newSubdocumentRef = newSubcollectionRef.document()

                                        newSubdocumentRef.setData([
                                            "userID": "",
                                            "timestamp": ""
                                        ])
                                        self.dismiss(animated: true, completion: nil)
                                        self.stopSpinner()
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}
    
    @IBAction func btnSelectPhoto(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: "Oops!", message: messageInput, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleInput, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
