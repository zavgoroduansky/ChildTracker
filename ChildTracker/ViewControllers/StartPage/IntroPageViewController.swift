//
//  IntroPageViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/7/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class IntroPageViewController: UIPageViewController {

    // MARK: UI
    private let pageControl: UIPageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
    
    // MARK: Properties
    private lazy var introViewControllers: [UIViewController & IntroPageViewControllersProtocol] = Router.introPageViewControllers()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
    }
}

private extension IntroPageViewController {
    
    func setupPageViewController() {
        
        dataSource = self
        delegate = self
        
        if let firstViewController = introViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        configurePageControl()
    }
    
    func configurePageControl() {
        
        // The total number of pages that are available is based on how many available colors we have.
        pageControl.numberOfPages = introViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.black
        view.addSubview(pageControl)
    }
}

extension IntroPageViewController {
    
    func showNextViewController(for viewController: (UIViewController & IntroPageViewControllersProtocol)?) -> Bool {
        
        if let currentController = viewController {
            
            if let nextViewController = self.pageViewController(self, viewControllerAfter: currentController) as? UIViewController & IntroPageViewControllersProtocol {
                // need to check controller before showing
                if currentController.completed {
                    self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
                    pageControl.currentPage = nextViewController.orderNumber
                }
            } else {
                // this is the last page
                return false
            }
        }
        
        return true
    }
}

extension IntroPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let pageContentViewController = pageViewController.viewControllers![0] as? IntroPageViewControllersProtocol {
            pageControl.currentPage = pageContentViewController.orderNumber
        }
    }
}

extension IntroPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let formattedViewController = viewController as? IntroPageViewControllersProtocol {
            
            let viewControllerOrderNumber = formattedViewController.orderNumber
            if viewControllerOrderNumber > 0 && viewControllerOrderNumber <= introViewControllers.count-1 {
                return introViewControllers[viewControllerOrderNumber-1]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let formattedViewController = viewController as? IntroPageViewControllersProtocol {
            
            let viewControllerOrderNumber = formattedViewController.orderNumber
            if viewControllerOrderNumber >= 0 && viewControllerOrderNumber < introViewControllers.count-1 {
                return introViewControllers[viewControllerOrderNumber+1]
            }
        }
        
        return nil
    }
}
