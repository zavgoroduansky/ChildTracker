//
//  DetailInfoView.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/12/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class DetailInfoView: DesignableView {
    
    // MARK: UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func setup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        contentView = view
    }
}
