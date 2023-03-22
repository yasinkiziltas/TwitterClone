//
//  AddProfilePictureViewController.swift
//  TwitterClone
//
//  Created by Admin on 17.03.2023.
//

import UIKit
import Firebase

class AddProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.layer.cornerRadius = 25
        btnNext.layer.borderWidth = 0.1
        btnNext.layer.backgroundColor = UIColor.lightGray.cgColor
        btnNext.layer.borderColor = UIColor.gray.cgColor
        
        imgView.isUserInteractionEnabled = true
        
        let imgTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImg))
        imgView.addGestureRecognizer(imgTapGestureRecognizer)
    }
    
    @objc func chooseImg() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func goNext(_ sender: Any) {
        
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        performSegue(withIdentifier: "toHomeFromProfilePic", sender: nil)
    }
}
