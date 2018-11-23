//
//  DetailButton.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/16/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class DetailButton: DesignableButton {

    override func setup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        contentView = view
        
        // Add our border here and every custom setup
        backgroundColor = UIColor.clear
        
        contentView.backgroundColor = UIColor(hexString: "#D4FFCFFF")
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = bounds.height / 2
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.masksToBounds = false
        contentView.layer.shadowRadius = 1.0
        contentView.layer.shadowOpacity = 0.5
    }
    
    func initButtonWith(tag: Int, title: String?, handler: ((UIButton) -> ())?) {
        super.initButtonWith(tag: tag, handler: handler)
        
        mainButton.setTitle(title, for: .normal)
    }
}
