//
//  FeedCell.swift
//  TwitterClone
//
//  Created by Admin on 26.03.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore

class FeedCell: UITableViewCell {

    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postedByEmail: UILabel!
    @IBOutlet weak var postedbyName: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    let db = Firestore.firestore()
    var isLiked = false
    let currentUserEmail = Auth.auth().currentUser?.email
    let currentUserID = Auth.auth().currentUser?.uid
    let image = UIImage(systemName: "heart")
    let imageFill = UIImage(systemName: "heart.fill")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeBtn.setImage(self.image, for: .normal)
        //getTweetLikeStatus()
    }
    
    func configureCell(documentID: String) {
        // Tweet referansını oluştur
        let tweetRef = db.collection("Tweets").document(documentID)
        let likesRef = tweetRef.collection("tweetLikes")
        
        // Beğeni durumunu kontrol et ve buton görünümünü ayarla
        likesRef.whereField("userID", isEqualTo: currentUserID).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot, !snapshot.documents.isEmpty {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    if let isLiked = data["isLiked"] as? Bool {
                        let imageName = isLiked ? "heart.fill" : "heart"
                        self.likeBtn.setImage(UIImage(systemName: imageName), for: .normal)
                    }
                }
            }
        }
    }
    
     
    @IBAction func likeBtnClicked(_ sender: Any) {
        let tweetRef = db.collection("Tweets").document(documentIdLabel.text!)
        let likesRef = tweetRef.collection("tweetLikes")
        
        // Kullanıcının "Like" butonuna tekrar tıkladığında
        if isLiked {
            
            //İlgili document bulma işlemi
            likesRef.whereField("userID", isEqualTo: currentUserID).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error removing like: \(error)")
                } else {
                    
                    //Tweets içersinideki likes countunu eksiltme işlemi
                    if let likeCount = Int(self.likeLabel.text!) {
                        let likeStore = ["likes" : likeCount - 1] as [String : Any]
                        
                        if likeStore.count != 0 {
                            self.db.collection("Tweets").document(self.documentIdLabel.text!).setData(likeStore, merge: true)
                        } else {
                            let likeStore = ["likes" : 0] as [String : Any]
                            self.db.collection("Tweets").document(self.documentIdLabel.text!).setData(likeStore, merge: true)
                        }
                    }
                    
                    //Document silme işlemi
                    guard let snapshot = snapshot else { return }
                    for document in snapshot.documents {
                        let data = document.data()
                        document.reference.delete()
                    }
                }
            }
            
            likeBtn.setImage(self.image, for: .normal)
            isLiked = false
            
            
        //Kullanıcının "Like" butonuna ilk kez tıkladığında
        } else {
            
            //tweetLikes dizisi oluşturma işlemi
            let likeData: [String: Any] = [
                "userEmail" : currentUserEmail,
                "userID": currentUserID,
                "timestamp": FieldValue.serverTimestamp(),
                "isLiked" : true,
            ]
 
            //tweetLikes dizisini firebase'e ekleme işlemi
            likesRef.whereField("userID", isEqualTo: currentUserID).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                if let snapshot = snapshot, snapshot.documents.count > 0 {
                    //print("Already liked.")
                } else {
                    self.likeBtn.setImage(self.imageFill, for: .normal)
                    likesRef.addDocument(data: likeData) { error in
                        if let error = error {
                            print("Error adding like: \(error)")
                        } else {
                            if let likeCount = Int(self.likeLabel.text!) {
                                let likeStore = ["likes" : likeCount + 1] as [String : Any]
                                self.db.collection("Tweets").document(self.documentIdLabel.text!).setData(likeStore, merge: true)
                            }
                        }
                }
            }
                self.isLiked = true
            }
        }
    }
    
    @IBAction func commendBtnClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func retweetBtnClicked(_ sender: Any) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
