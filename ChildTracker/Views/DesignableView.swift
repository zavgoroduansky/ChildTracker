//
//  DesignableView.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/9/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView {

    // MARK: UI
    @IBOutlet var contentView: UIView!

    // MARK: override
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        // need to override
    }
}
