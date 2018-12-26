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
        return [viewControllerWith(name: "GreetingViewController", in: "Main") as! UIViewController & IntroPageViewControllersProtocol,
                viewControllerWith(name: "InitialViewController", in: "Main") as! UIViewController & IntroPageViewControllersProtocol,
                viewControllerWith(name: "InfoViewController", in: "Main") as! UIViewController & IntroPageViewControllersProtocol]
    }
    
    static func prepareMainViewController() -> MainViewController {
        
        let controller = viewControllerWith(name: "MainViewController", in: "Main") as! MainViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let presenter = MainViewControllerPresenter()
        presenter.activityManager = appDelegate.activityManager
        presenter.viewController = controller
        
        appDelegate.activityManager.delegate = presenter
        
        controller.presenter = presenter
        
        return controller
    }
    
    static func prepareReportViewController() -> ReportViewController {
        
        let controller = viewControllerWith(name: "ReportViewController", in: "Main") as! ReportViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let reportManager = ReportManager(dataManager: appDelegate.dataManager)
        
        let presenter = ReportViewControllerPresenter()
        presenter.viewController = controller
        presenter.reportManager = reportManager
        
        controller.presenter = presenter
        
        return controller
    }
    
    static func prepareAdditionalViewController() -> AdditionalViewController {
        
        let controller = viewControllerWith(name: "AdditionalViewController", in: "Main") as! AdditionalViewController
        
        let presenter = AdditionalViewControllerPresenter()
        presenter.viewController = controller
        
        controller.presenter = presenter
        
        return controller
    }
    
    static func prepareMoreViewController() -> MoreViewController {
        
        let controller = viewControllerWith(name: "MoreViewController", in: "Main") as! MoreViewController
        
        return controller
    }
    
    static func prepareAddNewDeficationViewController(activity: DeficationType) -> AddNewActionViewController {
        
        let controller = AddNewDeficationViewController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let presenter = AddNewDeficationViewControllerPresenter()
        presenter.viewController = controller
        presenter.activity = activity
        presenter.dataManager = appDelegate.dataManager
        
        controller.presenter = presenter
        
        return controller
    }
}

private extension Router {
    
    static func viewControllerWith(name: String, in storyboardName: String) -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: name)
    }
}
