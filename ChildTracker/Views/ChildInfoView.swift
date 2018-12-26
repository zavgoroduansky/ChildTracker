//
//  ChildInfoView.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/25/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class ChildInfoView: DesignableView {

    // MARK: UI
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var labelsContainerView: UIView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childAgeLabel: UILabel!
    
    @IBAction func setImageButtonAction(_ sender: UIButton) {
        setImageHandler?(sender)
    }
    
    // MARK: Properties
    public var setImageHandler: ((UIButton) -> ())?
    
    override func setup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        contentView = view
        
        // Add our border here and every custom setup
    }
}
