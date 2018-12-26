//
//  MainTabBarViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/25/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // need to reset start view controller
        viewControllers?.removeAll()
        let reportController = Router.prepareReportViewController()
        let mainController = Router.prepareMainViewController()
        let additionalController = Router.prepareAdditionalViewController()
        let moreController = Router.prepareMoreViewController()
        
        viewControllers = [reportController, mainController, additionalController, moreController]
        
        selectedViewController = mainController
    }
}
