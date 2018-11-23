//
//  ReportViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/16/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation
import UIKit

class ReportViewControllerPresenter: NSObject {
    
    // MARK: Properties
    public weak var viewController: ReportViewController?
    public var reportManager: ReportManager?
}

// MARK: Public
extension ReportViewControllerPresenter {
    
    func setupCloseContainer(_ container: DetailButton) {
        
        container.initButtonWith(tag: 0, title: "X") { [unowned self] (sender) in
            self.viewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupTableView(_ tableView: UITableView) {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        reportManager?.locationTotalDuration(completion: { (success) in
            DispatchQueue.main.async {
                tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
            }
        })
        
        reportManager?.stateTotalDuration(completion: { (success) in
            DispatchQueue.main.async {
                tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            }
        })
    }
}

extension ReportViewControllerPresenter: UITableViewDelegate {
    
    
}

extension ReportViewControllerPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return reportManager?.locationData.count ?? 0
        case 1:
            return reportManager?.stateData.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Location"
        case 1:
            return "State"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
        
        switch indexPath.section {
        case 0:
            if let element = reportManager?.locationData[indexPath.row] {
                cell.textLabel?.text = element.location.title()
                cell.detailTextLabel?.text = FormatManager.formatDurationInSecondsFor(Int(element.duration))
            }
        case 1:
            if let element = reportManager?.stateData[indexPath.row] {
                cell.textLabel?.text = element.state.title()
                cell.detailTextLabel?.text = FormatManager.formatDurationInSecondsFor(Int(element.duration))
            }
        default: break
        }
        
        return cell
    }
}
