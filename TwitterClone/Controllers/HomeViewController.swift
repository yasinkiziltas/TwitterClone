//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Admin on 17.03.2023.
//

import UIKit
import Firebase
import SDWebImage
import SkeletonView

class HomeViewController: UIViewController, SkeletonTableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    var documentIdArray = [String]()
    var userEmailArray = [String]()
    var userNameArray = [String]()
    var userNickNameArray = [String]()
    var userTweetArray = [String]()
    var userTweetLikeArray = [Int]()
    var userTweetImgArray = [String]()
    
    let firestoreDatabase = Firestore.firestore()
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        tableView.rowHeight = 400
        tableView.estimatedRowHeight = 350
        tableView.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            for _ in 0..<30 {
                self.data.append("Hi")
            }
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self.tableView.reloadData()
        })
        getDataFromFirebase()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tableView.reloadData()
//    }
//
    func getDataFromFirebase() {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .gray), animation: nil, transition: .crossDissolve(0.25))
        
           firestoreDatabase.collection("Tweets")
               .order(by: "tweetDate", descending: true)
               .addSnapshotListener { (snapshot, error ) in
               if error != nil {
                   print(error?.localizedDescription)
               } else {
                   if snapshot?.isEmpty != true {
                       self.documentIdArray.removeAll(keepingCapacity: false)
                       self.userEmailArray.removeAll(keepingCapacity: false)
                       self.userNameArray.removeAll(keepingCapacity: false)
                       self.userNickNameArray.removeAll(keepingCapacity: false)
                       self.userTweetArray.removeAll(keepingCapacity: false)
                       self.userTweetLikeArray.removeAll(keepingCapacity: false)
                       self.userTweetImgArray.removeAll(keepingCapacity: false)
                       
                       for document in snapshot!.documents {
                         let documentID = document.documentID
                           self.documentIdArray.append(documentID)
                           
                           if let tweetContent = document.get("tweetContent") as? String {
                               self.userTweetArray.append(tweetContent)
                           }
                           
                           if let postedByName = document.get("postedByName") as? String {
                               self.userNameArray.append(postedByName)
                           }
                           
                           if let postedByEmail = document.get("postedByEmail") as? String {
                               self.userEmailArray.append(postedByEmail)
                           }
                           
                           
                           if let postedByNickName = document.get("postedByNickName") as? String {
                               self.userNickNameArray.append(postedByNickName)
                           }
                           
                           if let likes = document.get("likes") as? Int {
                               self.userTweetLikeArray.append(likes)
                           }
                           
                           if let imageUrl = document.get("imageURL") as? String {
                               self.userTweetImgArray.append(imageUrl)
                           }
                       }
                       self.tableView.reloadData()
                   } else {
                       print("Snapshot is empty")
                   }
               }
           }
       }
    
    @IBAction func btnAddTweet(_ sender: Any) {
        performSegue(withIdentifier: "toAddTweetVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTweetArray.count
    }
     
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return FeedCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
        
        if !data.isEmpty {
            cell.documentIdLabel.text = documentIdArray[indexPath.row]
            let documentID = documentIdArray[indexPath.row]
            cell.configureCell(documentID: documentID)
            cell.postedbyName.text = userNameArray[indexPath.row]
            cell.postedByEmail.text = "@\(userNickNameArray[indexPath.row])"
            cell.profileImg.image = UIImage(named: "apple.png")
            cell.postImg.sd_setImage(with: URL(string: self.userTweetImgArray[indexPath.row]))
            cell.commentLabel.text = userTweetArray[indexPath.row]
            cell.likeLabel.text = String(userTweetLikeArray[indexPath.row])
        }
        return cell
      
    }
}
