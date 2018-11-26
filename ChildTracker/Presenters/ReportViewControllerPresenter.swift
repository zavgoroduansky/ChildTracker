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
    
    private lazy var selectedSegment: Intervals = UserDefaultManager.fetchReportInterval() ?? Intervals.last12hours
}

// MARK: Public
extension ReportViewControllerPresenter {
    
    func setupCloseContainer(_ container: DetailButton) {
        
        container.initButtonWith(tag: 0, title: "X") { [unowned self] (sender) in
            self.viewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupSegmentedControl(_ container: SegmentedView) {
        
        container.setupView(dataSource: self, delegate: self)
        viewController?.segmentedContainer.setSelectedSegment(selectedSegment.rawValue)
    }
    
    func setupTableView(_ tableView: UITableView) {
        
        tableView.delegate = self
        tableView.dataSource = self
    
        reloadTableView(tableView)
    }
}

// MARK: Private
private extension ReportViewControllerPresenter {
    
    func reloadTableView(_ tableView: UITableView) {
        
        reportManager?.locationTotalDuration(interval: selectedSegment, completion: { (success) in
            DispatchQueue.main.async {
                tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
            }
        })
        
        reportManager?.stateTotalDuration(interval: selectedSegment, completion: { (success) in
            DispatchQueue.main.async {
                tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            }
        })
    }
}

// MARK: UITableViewDelegate
extension ReportViewControllerPresenter: UITableViewDelegate {
    
    
}

// MARK: UITableViewDataSource
extension ReportViewControllerPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return Location.allCases.count - 1
        case 1:
            return State.allCases.count - 1
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
                cell.detailTextLabel?.text = FormatManager.formatDurationForTimer(Int(element.duration))
            }
        case 1:
            if let element = reportManager?.stateData[indexPath.row] {
                cell.textLabel?.text = element.state.title()
                cell.detailTextLabel?.text = FormatManager.formatDurationForTimer(Int(element.duration))
            }
        default: break
        }
        
        return cell
    }
}

// MARK: SegmentedViewDataSource
extension ReportViewControllerPresenter: SegmentedViewDataSource {
    
    func numberOfSegments(_ segmentedControl: UISegmentedControl) -> Int {
        return Intervals.numberOfElements()
    }
    
    func segmentTitle(_ segmentedControl: UISegmentedControl, atIndex: Int) -> String? {
        
        if let interval = Intervals.init(rawValue: atIndex) {
            return interval.title()
        } else {
            return ""
        }
    }
}

// MARK: SegmentedViewDelegate
extension ReportViewControllerPresenter: SegmentedViewDelegate {
    
    func didSelectSegmentIn(_ segmentedControl: UISegmentedControl, withIndex: Int) {
        
        if let interval = Intervals.init(rawValue: withIndex) {
            UserDefaultManager.setReportInterval(interval)
            selectedSegment = interval
            
            guard let tableView = viewController?.mainTableView else { return }
            reloadTableView(tableView)
        }
    }
}

