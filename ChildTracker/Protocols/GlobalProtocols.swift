//
//  GlobalProtocols.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/7/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

protocol IntroPageViewControllersProtocol {
    
    var orderNumber: Int { get }
    var completed: Bool { get }
}

extension IntroPageViewControllersProtocol {
    
    var completed: Bool {
        return true
    }
}
