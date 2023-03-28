//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Admin on 17.03.2023.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.postedbyName.text = "Elon Musk"
        cell.postedByEmail.text = "@elonmuskk"
        cell.profileImg.image = UIImage(named: "apple.png")
        cell.postImg.image = UIImage(named: "google.jpg")
        return cell
    }
}
