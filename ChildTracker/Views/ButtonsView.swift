//
//  ButtonsView.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/24/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class ButtonsView: DesignableView {

    // MARK: UI
    @IBOutlet weak var leftButton: ActionButton!
    @IBOutlet weak var rightButton: ActionButton!
    
    override func setup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        contentView = view
        
        // Add our border here and every custom setup
        leftButton.layer.cornerRadius = 10
        leftButton.clipsToBounds = true
        
        rightButton.layer.cornerRadius = 10
        rightButton.clipsToBounds = true
    }
}
