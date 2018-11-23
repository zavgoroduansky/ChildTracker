//
//  DesignableButton.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/9/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class DesignableButton: DesignableView {

    // MARK: UI
    @IBOutlet weak var mainButton: UIButton!
    
    // MARK: Properties
    private var buttonHandler: ((UIButton) -> ())?

    // MARK: Actions
    @IBAction func mainButtonAction(_ sender: UIButton) {
        handleMainButtonAction(sender)
    }
    
    public func initButtonWith(tag: Int, handler: ((UIButton) -> ())?) {
        
        mainButton.tag = tag
        buttonHandler = handler
    }
    
    public func handleMainButtonAction(_ sender: UIButton) {
        buttonHandler?(sender)
    }
}
