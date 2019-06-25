//
//  BackPreviewViewController.swift
//  vikyc
//
//  Created by Aditya Chauhan on 25/06/19.
//  Copyright © 2019 Aditya Chauhan. All rights reserved.
//

import UIKit

import AVFoundation

class BackPreviewViewController: UIViewController {

    @IBOutlet var previewImage: UIImageView!
    var img: UIImage?
    
    
    
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImage.image = self.img
        
        UIGraphicsBeginImageContextWithOptions(previewImage.bounds.size, true, 0.0)
        
        previewImage.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        previewImage.image = croppedImage
        
    }
    
    
    

    
    @IBAction func proceed(_ sender: Any) {
        
       
        
        
        
        
    }
    
}
