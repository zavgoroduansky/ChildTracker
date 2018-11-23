//
//  Router.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/7/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class Router {
    
    static func introPageViewControllers() -> [UIViewController & IntroPageViewControllersProtocol] {
        return [viewControllerWith(name: "GreetingViewController") as! UIViewController & IntroPageViewControllersProtocol,
                viewControllerWith(name: "InitialViewController") as! UIViewController & IntroPageViewControllersProtocol,
                viewControllerWith(name: "InfoViewController") as! UIViewController & IntroPageViewControllersProtocol]
    }
    
    static func prepareMainViewController(_ controller: MainViewController) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let presenter = MainViewControllerPresenter()
        presenter.activityManager = appDelegate.activityManager
        presenter.viewController = controller
        
        appDelegate.activityManager.delegate = presenter
        
        controller.presenter = presenter
    }
    
    static func prepareReportViewController(_ controller: ReportViewController) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let reportManager = ReportManager(dataManager: appDelegate.dataManager)
        
        let presenter = ReportViewControllerPresenter()
        presenter.viewController = controller
        presenter.reportManager = reportManager
        
        controller.presenter = presenter
    }
}

private extension Router {
    
    static func viewControllerWith(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
}
