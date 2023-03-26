//
//  FeedCell.swift
//  TwitterClone
//
//  Created by Admin on 26.03.2023.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postedByEmail: UILabel!
    @IBOutlet weak var postedbyName: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func retweetBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func likeBtnClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func commendBtnClicked(_ sender: Any) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
