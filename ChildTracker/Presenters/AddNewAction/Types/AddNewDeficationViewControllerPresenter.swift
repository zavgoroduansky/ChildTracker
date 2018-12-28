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

// MARK: UITableViewDataSource
extension AddNewDeficationViewControllerPresenter {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BasicOpenableTableViewCell.identifier, for: indexPath) as! BasicOpenableTableViewCell
                
                cell.titleLabel.text = "Date:"
                cell.valueLabel.text = newAction.date.datePickerFormatString
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as! DatePickerTableViewCell
                
                cell.valueChangedHandler = { [unowned self = self] sender in
                    self.newAction.date = sender.date
                    tableView.reloadRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .automatic)
                }
                
                return cell
            }
        default:
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
}
