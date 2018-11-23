//
//  ViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/7/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class GreetingViewController: IntroPageBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension GreetingViewController: IntroPageViewControllersProtocol {
    
    var orderNumber: Int {
        return 0;
    }
}

