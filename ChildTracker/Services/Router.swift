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
    
    static func bottomPageViewControllers() -> [UIViewController & PageViewControllersProtocol] {
        return [prepareReportViewController(),
                prepareAdditionalViewController(),
                prepareMoreViewController()]
    }
    
    static func prepareMainViewController(_ controller: MainViewController) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let presenter = MainViewControllerPresenter()
        presenter.activityManager = appDelegate.activityManager
        presenter.viewController = controller
        
        appDelegate.activityManager.delegate = presenter
        
        controller.presenter = presenter
    }
    
    static func prepareReportViewController() -> (UIViewController & PageViewControllersProtocol) {
        
        let controller = viewControllerWith(name: "ReportViewController", in: "BottomPanel") as! ReportViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let reportManager = ReportManager(dataManager: appDelegate.dataManager)
        
        let presenter = ReportViewControllerPresenter()
        presenter.viewController = controller
        presenter.reportManager = reportManager
        
        controller.presenter = presenter
        
        return controller as UIViewController & PageViewControllersProtocol
    }
    
    static func prepareAdditionalViewController() -> (UIViewController & PageViewControllersProtocol) {
        
        let controller = viewControllerWith(name: "AdditionalViewController", in: "BottomPanel") as! AdditionalViewController
        
        let presenter = AdditionalViewControllerPresenter()
        presenter.viewController = controller
        
        controller.presenter = presenter
        
        return controller as UIViewController & PageViewControllersProtocol
    }
    
    static func prepareMoreViewController() -> (UIViewController & PageViewControllersProtocol) {
        
        let controller = viewControllerWith(name: "MoreViewController", in: "BottomPanel") as! MoreViewController
        
        return controller as UIViewController & PageViewControllersProtocol
    }
    
    static func prepareAddNewDeficationViewController(activity: DeficationType) -> AddNewActionViewController {
        
        let controller = AddNewDeficationViewController()
        controller.modalPresentationStyle = .overCurrentContext
        
        let presenter = AddNewDeficationViewControllerPresenter()
        presenter.viewController = controller
        
        controller.presenter = presenter
        controller.actionTitle = activity.title()
        
        return controller
    }
}

private extension Router {
    
    static func viewControllerWith(name: String, in storyboardName: String) -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: name)
    }
}
