//
//  AdditionalViewControllerPresenter.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/4/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation
import UIKit

class AdditionalViewControllerPresenter: NSObject {

    // MARK: Properties
    public weak var viewController: AdditionalViewController?
    public var dataManager: DataManager?
    
    private var deficationDataSource: [DeficationType : NewAction]?
}

// MARK: Public
extension AdditionalViewControllerPresenter {
    
    func setupTableView(_ tableView: UITableView) {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        reloadTableView(tableView)
    }
}

// MARK: Private
private extension AdditionalViewControllerPresenter {
    
    func reloadTableView(_ tableView: UITableView) {
        
        // need to reload table view here with data from server
        dataManager?.detailedHistoryDefications([DeficationType.wet, DeficationType.dirty, DeficationType.mixed], completion: { [unowned self = self] (resultDict) in
            self.deficationDataSource = resultDict
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        })
    }
    
    func indexPathForDeficationType(_ type: DeficationType) -> IndexPath {
        return IndexPath(row: type.rawValue, section: 0)
    }
}


// MARK: UITableViewDelegate
extension AdditionalViewControllerPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if let selectedDeficationType = DeficationType.init(rawValue: indexPath.row) {
                viewController?.showDetailViewController(Router.prepareAddNewDeficationViewController(activity: selectedDeficationType, delegate: self), sender: self)
            }
        case 1:
            viewController?.showDetailViewController(Router.prepareAddNewTemperatureViewController(delegate: self), sender: self)
        case 2:
            break
        default: break
        }
    }
}

// MARK: UITableViewDataSource
extension AdditionalViewControllerPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return DeficationType.allCases.count
        case 1:
            return 1
        case 2:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Defication"
        case 1:
            return "Temperature"
        case 2:
            return "Custom"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
        
        switch indexPath.section {
        case 0:
            if let currentDeficationType = DeficationType.init(rawValue: indexPath.row) {
                cell.textLabel?.text = currentDeficationType.title()
                var detailText = "Never"
                if let action = deficationDataSource?[currentDeficationType] {
                    detailText = "\(FormatManager.formatDayDifference(for: action.date))"
                }
                cell.detailTextLabel?.text = "Last time: \(detailText)"
            }
        case 1:
            cell.textLabel?.text = "Temperature"
            cell.detailTextLabel?.text = "data from server"
        case 2:
            cell.textLabel?.text = "Custom activity"
            cell.detailTextLabel?.text = "data from server"
        default: break
        }
        
        return cell
    }
}

extension AdditionalViewControllerPresenter: NewActionDelegate {
    
    func didUpdateDeficationState(type: DeficationType) {
        
        dataManager?.detailedHistoryDefications([type], completion: { [unowned self = self] (resultDict) in
            self.deficationDataSource?.merge(dict: resultDict)
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadRows(at: [self.indexPathForDeficationType(type)], with: .fade)
            }
        })
    }
}
