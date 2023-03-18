//
//  AddProfilePictureViewController.swift
//  TwitterClone
//
//  Created by Admin on 17.03.2023.
//

import UIKit

class AddProfilePictureViewController: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.layer.cornerRadius = 25
        btnNext.layer.borderWidth = 0.1
        btnNext.layer.backgroundColor = UIColor.lightGray.cgColor
        btnNext.layer.borderColor = UIColor.gray.cgColor
    }

    @IBAction func goNext(_ sender: Any) {
        
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        performSegue(withIdentifier: "toHomeFromProfilePic", sender: nil)
    }
}
