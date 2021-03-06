//
//  ShimmeringLabel.swift
//  TimBanCu
//
//  Created by Vy Le on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ShimmeringLabel: UILabel {
    
    init(textColor: UIColor, view: UIView) {
        super.init(frame: CGRect(x: 0, y: CGFloat(view.frame.height / 6), width: view.frame.width, height: 100))
        self.text = Constants.App.name
        self.font = UIFont(name: Constants.App.font, size: UIScreen.main.bounds.size.width / Constants.App.fontSizeRatioWithScreen)
        self.textColor = textColor
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
