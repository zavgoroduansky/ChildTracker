//
//  AddNewActionViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/12/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class AddNewActionViewController: BaseViewController {

    // MARK: Properties
    public var presenter: AddNewActionViewControllerPresenter?
    public var showValueSection = false
    
    // MARK: UI
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var valueTitleView: DetailInfoView!
    @IBOutlet weak var valuePickerView: UIPickerView!
    @IBOutlet weak var valuePickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateTitleView: DetailInfoView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var datePickerViewHeightConstraint: NSLayoutConstraint!
    @IBAction func datePickerViewAction(_ sender: UIDatePicker) {
    }
    @IBOutlet weak var commentTitleView: DetailInfoView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewElements()
    }
}

private extension AddNewActionViewController {
    
    func setupViewElements() {
        
        mainContainerView.layer.cornerRadius = 20
        mainContainerView.clipsToBounds = true
        
        valueTitleView.isHidden = !showValueSection
        valuePickerView.isHidden = !showValueSection
        
        valueTitleView.titleLabel.text = "Value:"
        valueTitleView.valueLabel.text = ""

        dateTitleView.titleLabel.text = "Date:"
        dateTitleView.valueLabel.text = ""

        commentTitleView.titleLabel.text = "Comment:"
        commentTitleView.valueLabel.text = ""
        
        valuePickerView.delegate = presenter
        valuePickerView.dataSource = presenter
    }
}
