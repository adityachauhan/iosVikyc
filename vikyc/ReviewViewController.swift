//
//  ReviewViewController.swift
//  vikyc
//
//  Created by Aditya Chauhan on 24/06/19.
//  Copyright © 2019 Aditya Chauhan. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var prevImage: UIImageView!
    var img: UIImage?
    
    @IBOutlet var fname: UITextField!
    @IBOutlet var lname: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var address2: UITextField!
    @IBOutlet var dob: UITextField!
    @IBOutlet var dlnumber: UITextField!
    @IBOutlet var issueDate: UITextField!
    @IBOutlet var expiryDate: UITextField!
   
    var firstName: String?
    var lastname: String?
    var add1: String?
    var add2: String?
    var DOB: String?
    var dln: String?
    var isD: String?
    var exD: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prevImage.image = self.img
        fname.text = self.firstName
        lname.text = self.lastname
        address.text = self.add1
        address2.text = self.add2
        dob.text = self.DOB
        dlnumber.text = self.dln
        issueDate.text = self.isD
        expiryDate.text = self.exD
        
//        fname.delegate = self
//        lname.delegate = self
//        address.delegate = self
//        address2.delegate = self
//        dob.delegate = self
//        dlnumber.delegate = self
//        issueDate.delegate = self
//        expiryDate.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    

    @IBAction func submit(_ sender: Any) {
        performSegue(withIdentifier: "submitSegue", sender: nil)
    }
    
    

}


