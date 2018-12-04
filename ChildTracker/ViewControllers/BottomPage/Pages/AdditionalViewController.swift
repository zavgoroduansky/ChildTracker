//
//  AdditionalViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/3/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class AdditionalViewController: BaseViewController {

    // MARK: Properties
    public var presenter: AdditionalViewControllerPresenter?
    
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension AdditionalViewController: PageViewControllersProtocol {
    
    var orderNumber: Int {
        return 1
    }
}
