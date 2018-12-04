//
//  BottomPageViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/3/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

protocol BottomPageViewControllerDelegate: AnyObject {
    
    func setSection(withIndex: Int)
}

class BottomPageViewController: UIPageViewController {
    
    // MARK: Properties
    private lazy var pageViewControllers: [UIViewController & PageViewControllersProtocol] = Router.bottomPageViewControllers()
    public weak var container: BottomPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
    }
}

private extension BottomPageViewController {
    
    func setupPageViewController() {
        
        dataSource = self
        delegate = self
        
        if let firstViewController = pageViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
}

extension BottomPageViewController {
    
    func showViewController(withIndex: Int) {
        
        let selectedPage = pageViewControllers[withIndex]
        setViewControllers([selectedPage], direction: .forward, animated: true, completion: nil)
    }
}

extension BottomPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let pageContentViewController = pageViewController.viewControllers![0] as? PageViewControllersProtocol {
            container?.setSection(withIndex: pageContentViewController.orderNumber)
        }
    }
}

extension BottomPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let formattedViewController = viewController as? PageViewControllersProtocol {
            
            let viewControllerOrderNumber = formattedViewController.orderNumber
            if viewControllerOrderNumber > 0 && viewControllerOrderNumber <= pageViewControllers.count-1 {
                return pageViewControllers[viewControllerOrderNumber-1]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let formattedViewController = viewController as? PageViewControllersProtocol {
            
            let viewControllerOrderNumber = formattedViewController.orderNumber
            if viewControllerOrderNumber >= 0 && viewControllerOrderNumber < pageViewControllers.count-1 {
                return pageViewControllers[viewControllerOrderNumber+1]
            }
        }
        
        return nil
    }
}
