//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Admin on 17.03.2023.
//

import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var documentIdArray = [String]()
    var userEmailArray = [String]()
    var userTweetArray = [String]()
    var userTweetLikeArray = [Int]()
    var userTweetImgArray = [String]()
    
    let firestoreDatabase = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
      
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        getDataFromFirebase()
        
    }
    
    func getDataFromFirebase() {
        firestoreDatabase.collection("Tweets")
            .order(by: "tweetDate", descending: true)
            .addSnapshotListener { (snapshot, error ) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true {
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    self.userTweetArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userTweetImgArray.removeAll(keepingCapacity: false)
                    self.userTweetLikeArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                      let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let tweetContent = document.get("tweetContent") as? String {
                            self.userTweetArray.append(tweetContent)
                        }
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let likes = document.get("likes") as? Int {
                            self.userTweetLikeArray.append(likes)
                        }
                        
                        if let imageUrl = document.get("imageURL") as? String {
                            self.userTweetImgArray.append(imageUrl)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTweetArray.count
    }
    
    @IBAction func btnAddTweet(_ sender: Any) {
        performSegue(withIdentifier: "toAddTweetVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        let documentID = documentIdArray[indexPath.row]
        cell.configureCell(documentID: documentID)
        cell.postedbyName.text = "Twitter User"
        cell.postedByEmail.text =  userEmailArray[indexPath.row]
        cell.profileImg.image = UIImage(named: "apple.png")
        cell.postImg.sd_setImage(with: URL(string: self.userTweetImgArray[indexPath.row]))
        cell.commentLabel.text = userTweetArray[indexPath.row]
        cell.likeLabel.text = String(userTweetLikeArray[indexPath.row])
        return cell
    }
}
