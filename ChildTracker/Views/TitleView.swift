//
//  TitleView.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/24/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class TitleView: DesignableView {

    // MARK: UI
    @IBOutlet weak var titleLabel: UILabel!
    
    override func setup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        contentView = view
        
        // Add our border here and every custom setup
    }
}
