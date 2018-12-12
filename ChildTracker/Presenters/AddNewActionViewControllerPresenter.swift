//
//  AddNewActionViewControllerPresenter.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/12/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class AddNewActionViewControllerPresenter: NSObject {

    // MARK: Properties
    public weak var viewController: AddNewActionViewController?
}

// MARK: Public
extension AddNewActionViewControllerPresenter {

    
}

// MARK: UIPickerViewDataSource
extension AddNewActionViewControllerPresenter: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
}

// MARK: UIPickerViewDelegate
extension AddNewActionViewControllerPresenter: UIPickerViewDelegate {
    
}
