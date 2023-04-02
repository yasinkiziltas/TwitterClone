//
//  AddTweetViewController.swift
//  TwitterClone
//
//  Created by Admin on 28.03.2023.
//

import UIKit

class AddTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetArea: UITextView!
    let placeholderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetArea.delegate = self
        view.addSubview(tweetArea)
        
        placeholderLabel.text = "Write something.."
        placeholderLabel.font = tweetArea.font // metin giriş kutusuyla aynı font
        placeholderLabel.sizeToFit()
        tweetArea.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: tweetArea.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tweetArea.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
            placeholderLabel.isHidden = !tweetArea.text.isEmpty
        }
  
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true ,completion: nil)
    }
    
    @IBAction func btnTweet(_ sender: Any) {
        
    }
}
