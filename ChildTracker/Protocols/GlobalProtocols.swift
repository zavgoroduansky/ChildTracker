//
//  GlobalProtocols.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/7/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation
import UIKit

protocol PageViewControllersProtocol {
    
    var orderNumber: Int { get }
}

protocol IntroPageViewControllersProtocol: PageViewControllersProtocol {
    
    var completed: Bool { get }
}

extension IntroPageViewControllersProtocol {
    
    var completed: Bool {
        return true
    }
}

protocol RotatableView {
    
    func rotateView(_ view: UIView, toAngle: CGFloat)
}

extension RotatableView {
    
    func rotateView(_ view: UIView, toAngle: CGFloat) {
        view.transform = view.transform.rotated(by: toAngle)
    }
}
