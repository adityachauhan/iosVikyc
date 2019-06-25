//
//  AlertService.swift
//  vikyc
//
//  Created by Aditya Chauhan on 24/06/19.
//  Copyright © 2019 Aditya Chauhan. All rights reserved.
//

import UIKit

class AlertService {
    func alert() -> InstructionViewController{
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! InstructionViewController
        
        return alertVC
    }
}
