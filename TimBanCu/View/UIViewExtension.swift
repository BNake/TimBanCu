//
//  UIViewExtension.swift
//  TimBanCu
//
//  Created by Vy Le on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

extension UIViewController {
    func addNavigationBarShadow() {
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.shadowRadius = 3
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
}

extension UIView {
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(side: ViewSide, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        layer.addSublayer(border)
    }
}

