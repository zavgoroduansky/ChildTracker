//
//  SimpleButton.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/4/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class SimpleButton: UIButton {
    
    // MARK: UI
    @IBInspectable var normalBackgroundColor: UIColor {
        didSet {
            setBackgroundImage(UIImage.init(color: normalBackgroundColor), for: .normal)
        }
    }
    
    @IBInspectable var selectedBackgroundColor: UIColor {
        didSet {
            setBackgroundImage(UIImage.init(color: selectedBackgroundColor), for: .selected)
        }
    }
    
    override init(frame: CGRect) {
        
        normalBackgroundColor = UIColor.lightGray
        selectedBackgroundColor = UIColor.darkGray
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        normalBackgroundColor = UIColor.lightGray
        selectedBackgroundColor = UIColor.darkGray
        
        super.init(coder: aDecoder)
    }
}
