//
//  AddNewActionViewControllerPresenter.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/12/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

protocol NewActionDelegate: AnyObject {
    
    func didUpdateDeficationState(type: DeficationType)
}

class AddNewActionViewControllerPresenter: NSObject {

    // MARK: Properties
    public var dataManager: DataManager?
    public weak var delegate: NewActionDelegate?
    public weak var viewController: AddNewActionViewController?
    public var showValueSection: Bool {
        return false
    }
    
    public var newAction: NewAction = NewAction()   // need to think about it and totaly removed
    
    private var showValuePicker = false
    private var showDatePicker = false
    
    func saveNewAction() {
        // need to override
    }
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
    
    func setupButtonsPart(_ buttonsView: ButtonsView) {
        
        buttonsView.leftButton.title = "Close"
        buttonsView.leftButton.titleColor = UIColor.red
        buttonsView.leftButton.initButtonWith(tag: 0) { [unowned self = self] (button) in
            self.viewController?.dismiss(animated: true, completion: nil)
        }
        
        buttonsView.rightButton.title = "Done"
        buttonsView.rightButton.titleColor = UIColor.black
        buttonsView.rightButton.initButtonWith(tag: 1) { [unowned self = self] (button) in
            // need to save to db
            self.saveNewAction()
            self.viewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func setFirstResponder(_ tableView: UITableView) {
        
        let commentCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! TextViewTableViewCell
        commentCell.textView.becomeFirstResponder()
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
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BasicOpenableTableViewCell.identifier, for: indexPath) as! BasicOpenableTableViewCell
                
                cell.titleLabel.text = "Comment:"
                cell.valueLabel.text = newAction.comment
                cell.stateImage.isHidden = true
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
                cell.textView.delegate = self
                return cell
            }
        default: break
        }
        
        return UITableViewCell()
    }
}

// MARK: UITextViewDelegate
extension AddNewActionViewControllerPresenter: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        newAction.comment = textView.text
    }
}
