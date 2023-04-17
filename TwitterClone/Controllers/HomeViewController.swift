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
    var documentIdArray = [String]()
    var userEmailArray = [String]()
    var userTweetArray = [String]()
    var userTweetLikeArray = [Int]()
    var userTweetImgArray = [String]()
    
    let firestoreDatabase = Firestore.firestore()
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        tableView.rowHeight = 400
        tableView.estimatedRowHeight = 350
        //tableView.delegate = self
        tableView.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            for _ in 0..<30 {
                self.data.append("Hi")
            }
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self.getDataFromFirebase()
            self.tableView.reloadData()
        })
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .gray), animation: nil, transition: .crossDissolve(0.25))
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
            cell.postedbyName.text = "Twitter User"
            cell.postedByEmail.text =  userEmailArray[indexPath.row]
            cell.profileImg.image = UIImage(named: "apple.png")
            cell.postImg.sd_setImage(with: URL(string: self.userTweetImgArray[indexPath.row]))
            cell.commentLabel.text = userTweetArray[indexPath.row]
            cell.likeLabel.text = String(userTweetLikeArray[indexPath.row])
          
        }
        return cell
      
    }
}
