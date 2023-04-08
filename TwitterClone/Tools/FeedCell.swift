//
//  FeedCell.swift
//  TwitterClone
//
//  Created by Admin on 26.03.2023.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postedByEmail: UILabel!
    @IBOutlet weak var postedbyName: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    var isLiked = false
    let currentUserEmail = Auth.auth().currentUser?.email
    let currentUserID = Auth.auth().currentUser?.uid
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func retweetBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func likeBtnClicked(_ sender: Any) {
        let db = Firestore.firestore()
        let tweetRef = db.collection("Tweets").document(documentIdLabel.text!)
        let likesRef = tweetRef.collection("tweetLikes")
        
        if isLiked {
                // Kullanıcının "Like" butonuna tekrar tıkladığında
            if let likeCount = Int(likeLabel.text!) {
                let likeStore = ["likes" : likeCount - 1] as [String : Any]
                
                if likeStore.count != 0 {
                    db.collection("Tweets").document(documentIdLabel.text!).setData(likeStore, merge: true)
                } else {
                    let likeStore = ["likes" : 0] as [String : Any]
                    db.collection("Tweets").document(documentIdLabel.text!).setData(likeStore, merge: true)
                }
            }
                likesRef.whereField("userID", isEqualTo: currentUserID).getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error removing like: \(error)")
                    } else {
                        guard let snapshot = snapshot else { return }
                        for document in snapshot.documents {
                            document.reference.delete()
                        }
                    }
                }
                
                isLiked = false
                // Butonun rengini değiştirin veya benzeri bir geri bildirim yapın
            
            //Kullanıcının "Like" butonuna ilk kez tıkladığında
            } else {
                if let likeCount = Int(likeLabel.text!) {
                    let likeStore = ["likes" : likeCount + 1] as [String : Any]
                    db.collection("Tweets").document(documentIdLabel.text!).setData(likeStore, merge: true)
                }
                let likeData: [String: Any] = [
                    "userEmail" : currentUserEmail,
                    "userID": currentUserID,
                    "timestamp": FieldValue.serverTimestamp()
                ]
                
                likesRef.addDocument(data: likeData) { error in
                    if let error = error {
                        print("Error adding like: \(error)")
                    }
                }
                
                isLiked = true
                // Butonun rengini değiştirin veya benzeri bir geri bildirim yapın
            }
          
        
    }
    
    @IBAction func commendBtnClicked(_ sender: Any) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
