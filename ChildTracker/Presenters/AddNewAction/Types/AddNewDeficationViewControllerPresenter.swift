//
//  AddNewDeficationViewControllerPresenter.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/13/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class AddNewDeficationViewControllerPresenter: AddNewActionViewControllerPresenter {
    
    // MARK: Properties
    override public var showValueSection: Bool {
        return false
    }
    public var activity: DeficationType?
    
    // MARK: Override
    override func saveNewAction() {
        if let activityType = activity {
            dataManager?.addNewDefication(activityType, date: newAction.date, comment: newAction.comment) { (success) in
                self.delegate?.didUpdateDeficationState(type: activityType)
            }
        }
    }
}
