//
//  InfoViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/7/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class InfoViewController: IntroPageBaseViewController {

    // MARK: UI
    @IBOutlet weak var infoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViewElements()
    }
}

private extension InfoViewController {

    func setupViewElements() {
        infoTextView.text = DefaultValues.defaultInfoText.replacingOccurrences(of: "%name%", with: ChildManager.child.name)
    }
}

extension InfoViewController: IntroPageViewControllersProtocol {
    
    var orderNumber: Int {
        return 2;
    }
}
