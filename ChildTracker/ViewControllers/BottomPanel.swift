//
//  BottomPanel.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/27/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit
import Panels

class BottomPanel: UIViewController, Panelable {
    
    // MARKL Properties
    var headerPanel: UIView! {
        return tabBar
    }

    // MARK: UI
    @IBOutlet var headerHeight: NSLayoutConstraint!
    @IBOutlet var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
