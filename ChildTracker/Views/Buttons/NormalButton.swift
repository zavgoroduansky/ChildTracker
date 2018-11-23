//
//  NormalButton.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/7/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class NormalButton: DesignableButton {

    override func setup() {

        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        contentView = view

        // Add our border here and every custom setup
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 5
        contentView.layer.borderColor = UIColor.white.cgColor
        mainButton.titleLabel!.font = UIFont.systemFont(ofSize: 25)
    }
}
