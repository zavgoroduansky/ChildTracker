//
//  AdditionalViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/3/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class AdditionalViewController: BaseViewController {

    // MARK: Properties
    public var presenter: AdditionalViewControllerPresenter?
    
    // MARK: UI
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButtonAction(_ sender: UIButton) {
        // need to add some custom activity
    }
    
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewElements()
    }
}

private extension AdditionalViewController {
    
    func setupViewElements() {
        
        presenter?.setupTableView(tableView)
    }
}

extension AdditionalViewController: PageViewControllersProtocol {
    
    var orderNumber: Int {
        return 1
    }
}
