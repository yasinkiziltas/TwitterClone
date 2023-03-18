//
//  ViewController.swift
//  TwitterClone
//
//  Created by Admin on 16.03.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnAccountRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnGoogle.layer.cornerRadius = 25
        btnGoogle.layer.borderWidth = 0.5
        btnGoogle.layer.borderColor = UIColor.gray.cgColor
        
        btnApple.layer.cornerRadius = 25
        btnApple.layer.borderWidth = 0.5
        btnApple.layer.borderColor = UIColor.gray.cgColor
        
        btnAccountRegister.layer.cornerRadius = 25
        btnAccountRegister.layer.borderWidth = 0.5
        btnAccountRegister.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        performSegue(withIdentifier: "toRegister", sender: nil)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
}

