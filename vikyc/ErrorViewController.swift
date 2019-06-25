//
//  ErrorViewController.swift
//  vikyc
//
//  Created by Aditya Chauhan on 24/06/19.
//  Copyright © 2019 Aditya Chauhan. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {

    @IBOutlet var image: UIImageView!
    var img: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = self.img
    }
    

    @IBAction func rescan(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    

}
