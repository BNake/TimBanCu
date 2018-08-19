//
//  NoResultAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

// should not subclass uialertcontroller because of https://developer.apple.com/documentation/uikit/uialertcontroller#//apple_ref/doc/uid/TP40014538-CH1-SW2
class InfoAlert{
    
    static func getAlert(title:String,message:String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
        }))
        
        return alert
    }
    
    static func getAlert(title:String,message:String, action:UIAlertAction) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        
        return alert
    }
}
