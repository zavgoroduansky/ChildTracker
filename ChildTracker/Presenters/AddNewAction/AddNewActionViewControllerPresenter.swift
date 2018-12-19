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
    public var showValueSection: Bool {
        return false
    }
    
    private var showValuePicker = false
    private var showDatePicker = false
    private var actionDate: Date = Date()
}

// MARK: Public
extension AddNewActionViewControllerPresenter {

    func setupTableView(_ tableView: UITableView) {
        
        // need to setup cells
        tableView.register(UINib(nibName: "BasicOpenableTableViewCell", bundle: nil), forCellReuseIdentifier: BasicOpenableTableViewCell.identifier)
        tableView.register(UINib(nibName: "ValuePickerTableViewCell", bundle: nil), forCellReuseIdentifier: ValuePickerTableViewCell.identifier)
        tableView.register(UINib(nibName: "DatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: DatePickerTableViewCell.identifier)
        tableView.register(UINib(nibName: "TextViewTableViewCell", bundle: nil), forCellReuseIdentifier: TextViewTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: UITableViewDelegate
extension AddNewActionViewControllerPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            if showValueSection {
                if indexPath.row == 1 {
                    return showValuePicker ? ValuePickerTableViewCell.normalHeight : 0
                }
            } else {
                return 0
            }
        case 1:
            if indexPath.row == 1 {
                return showDatePicker ? DatePickerTableViewCell.normalHeight : 0
            }
        case 2:
            if indexPath.row == 1 {
                return TextViewTableViewCell.normalHeight
            }
        default: break
        }
        
        return BasicOpenableTableViewCell.normalHeight   // normal height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                tableView.beginUpdates()
                showValuePicker = !showValuePicker
                tableView.endUpdates()
            }
        case 1:
            if indexPath.row == 0 {
                tableView.beginUpdates()
                showDatePicker = !showDatePicker
                tableView.endUpdates()
            }
        default: break
        }
    }
}

// MARK: UITableViewDataSource
extension AddNewActionViewControllerPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BasicOpenableTableViewCell.identifier, for: indexPath) as! BasicOpenableTableViewCell
                
                cell.titleLabel.text = "Value:"
                cell.valueLabel.text = ""
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ValuePickerTableViewCell.identifier, for: indexPath)
                
                // need to set values for picker
                
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BasicOpenableTableViewCell.identifier, for: indexPath) as! BasicOpenableTableViewCell
                
                cell.titleLabel.text = "Date:"
                cell.valueLabel.text = actionDate.datePickerFormatString
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as! DatePickerTableViewCell
                
                cell.valueChangedHandler = { [unowned self = self] sender in
                    self.actionDate = sender.date
                    tableView.reloadRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .automatic)
                }
                
                return cell
            }
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BasicOpenableTableViewCell.identifier, for: indexPath) as! BasicOpenableTableViewCell
                
                cell.titleLabel.text = "Comment:"
                cell.valueLabel.text = ""
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath)
                return cell
            }
        default: break
        }
        
        return UITableViewCell()
    }
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
