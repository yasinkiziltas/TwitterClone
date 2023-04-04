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

    @IBOutlet weak var tweetArea: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imgView: UIImageView!
    let placeholderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetArea.delegate = self
        view.addSubview(tweetArea)
        
        imgView.isUserInteractionEnabled = true
        stopSpinner()
        
        placeholderLabel.text = "Write something.."
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
    
    @IBAction func btnTweet(_ sender: Any) {
        startSpinner()
        if imgView.image == nil {
            let firestoreDB = Firestore.firestore()
            var firestoreRf: DocumentReference? = nil
            let firestorePostWithoutImg = ["imageURL" : "", "postedBy": Auth.auth().currentUser!.email, "tweetContent": self.tweetArea.text!, "tweetDate": FieldValue.serverTimestamp(), "likes" : 0] as [String: Any]
            
            firestoreRf = firestoreDB.collection("Tweets").addDocument(data: firestorePostWithoutImg, completion: { (error) in
                if error != nil {
                    self.stopSpinner()
                    self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                } else {
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
                                let firestorePost = ["imageURL" : imageURL!, "postedBy": Auth.auth().currentUser!.email, "tweetContent": self.tweetArea.text!, "tweetDate": FieldValue.serverTimestamp(), "likes" : 0] as [String: Any]
                                
                                firestoreRef = firestoreDatabase.collection("Tweets").addDocument(data: firestorePost, completion: { (error) in
                                    if error != nil {
                                        self.stopSpinner()
                                        self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                                    } else {
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
