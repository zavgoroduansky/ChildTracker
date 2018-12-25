//
//  ActionButton.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/24/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class ActionButton: DesignableButton {

    // MARK: Properties
    public var titleColor: UIColor? {
        didSet {
            mainButton.setTitleColor(titleColor, for: .normal)
        }
    }
    
    public var title: String? {
        didSet {
            mainButton.setTitle(title, for: .normal)
        }
    }
    
    override func setup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        contentView = view
        
        // Add our border here and every custom setup
    }
}
