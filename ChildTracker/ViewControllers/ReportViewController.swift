//
//  ReportViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/16/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class ReportViewController: BaseViewController {

    // MARK: Properties
    public var presenter: ReportViewControllerPresenter?
    
    // MARK: UI
    @IBOutlet weak var closeContainer: DetailButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewElements()
    }
}

private extension ReportViewController {
    
    func setupViewElements() {
        
        presenter?.setupTableView(mainTableView)
        presenter?.setupCloseContainer(closeContainer)
    }
}
