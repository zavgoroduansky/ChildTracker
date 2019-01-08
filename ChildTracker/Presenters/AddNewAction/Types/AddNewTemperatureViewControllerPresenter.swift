//
//  AddNewTemperatureViewControllerPresenter.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/28/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class AddNewTemperatureViewControllerPresenter: AddNewActionViewControllerPresenter {

    // MARK: Properties
    override public var showValueSection: Bool {
        return true
    }
    
    private var selectedTemperature: Double = 36.6
    private var temperatureArray: [Double] {
        var result = [Double]()
        for i in 35...39 {
            for j in 0...9 {
                result.append(Double(i) + Double(j)/10)
            }
        }
        result.append(40.0)
        return result
    }
    
    // MARK: Override
    override func saveNewAction() {
        dataManager?.addNewTemperature(selectedTemperature, date: newAction.date, comment: newAction.comment, completion: { (success) in
            self.delegate?.didUpdateTemperature()
        })
    }
}

// MARK: UITableViewDataSource
extension AddNewTemperatureViewControllerPresenter {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BasicOpenableTableViewCell.identifier, for: indexPath) as! BasicOpenableTableViewCell
                
                cell.titleLabel.text = "Value:"
                cell.valueLabel.text = "\(selectedTemperature)"
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ValuePickerTableViewCell.identifier, for: indexPath) as! ValuePickerTableViewCell
                
                cell.pickerView.delegate = self
                cell.pickerView.dataSource = self
                
                if let index = temperatureArray.index(of: selectedTemperature) {
                    cell.pickerView.selectRow(index, inComponent: 0, animated: true)
                }
                
                return cell
            }
        default:
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
}

// MARK: UIPickerViewDataSource
extension AddNewTemperatureViewControllerPresenter: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return temperatureArray.count
    }
}

// MARK: UIPickerViewDelegate
extension AddNewTemperatureViewControllerPresenter: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(temperatureArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTemperature = temperatureArray[row]
        viewController?.updateTableView(for: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}
