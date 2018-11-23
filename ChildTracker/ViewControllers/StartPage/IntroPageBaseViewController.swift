//
//  IntroPageBaseViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/8/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class IntroPageBaseViewController: BaseViewController {

    // MARK: UI
    @IBOutlet weak var nextButton: NormalButton!
    
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }

    // MARK: Override
    func prepareChildStruct() -> Child? {
        // need to override
        return nil
    }
}

private extension IntroPageBaseViewController {
    
    func setupViewController() {
        nextButton.initButtonWith(tag: 0) { [unowned self = self] (sender) in
            self.nextButtonHandler()
        }
    }
}

extension IntroPageBaseViewController {
    
    func nextButtonHandler() {
        
        if let parentPageViewController = parent as? IntroPageViewController {
            
            // save child
            if let userChild = prepareChildStruct() {
                ChildManager.child = userChild
            }
            
            if !parentPageViewController.showNextViewController(for: (self as? UIViewController & IntroPageViewControllersProtocol)) {
                UserDefaultManager.finishFirstLaunch()
                // need to close page view controller
                parentPageViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
