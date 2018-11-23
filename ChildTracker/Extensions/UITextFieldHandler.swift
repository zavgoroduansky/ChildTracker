//
//  UITextFieldHandler.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/8/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

extension UITextField {
    
    func checkName() -> String? {
        
        guard let selectedName = text else {
            return nil
        }
        
        return selectedName.count > 0 ? selectedName : nil
    }
    
    func checkWeightGrowth() -> String? {
        
        guard let selectedValue = text else {
            return nil
        }
        
        return selectedValue.count > 0 ? selectedValue : nil
    }
}
