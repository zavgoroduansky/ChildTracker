//
//  BottomPanel.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/27/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit
import Panels

protocol BottomPanelViewControllerDelegate: AnyObject {
    
    var buttonsActionIsAvailable: Bool { get }
    
    func openBottomPanel()
    func closeBottomPanel()
}

class BottomPanelViewController: UIViewController, Panelable {
    
    // MARKL Properties
    var pageViewController: BottomPageViewController?
    public weak var delegate: BottomPanelViewControllerDelegate?

    // MARK: UI
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var headerHeight: NSLayoutConstraint!
    @IBOutlet var headerPanel: UIView!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var reportsButton: SimpleButton!
    @IBOutlet weak var additionalButton: SimpleButton!
    @IBOutlet weak var moreButton: SimpleButton!
    
    @IBAction func panelButtonAction(_ sender: UIButton) {
        
        turnOffButtonsSelection()
        sender.isSelected = !sender.isSelected
        
        // need to set selected page
        pageViewController?.showViewController(withIndex: sender.tag)
        
        if let buttonsActionIsAvailable = delegate?.buttonsActionIsAvailable {
            if !buttonsActionIsAvailable {
                delegate?.openBottomPanel()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViewElements()
    }
    
    // navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        pageViewController = segue.destination as? BottomPageViewController
        pageViewController?.container = self
    }
}

private extension BottomPanelViewController {
    
    func simpleButtonWithTag(_ tag: Int) -> SimpleButton? {
        
        switch tag {
        case 0:
            return reportsButton
        case 1:
            return additionalButton
        case 2:
            return moreButton
        default:
            return nil
        }
    }
    
    func turnOffButtonsSelection() {
        
        reportsButton.isSelected = false
        additionalButton.isSelected = false
        moreButton.isSelected = false
    }
    
    func prepareViewElements() {
        
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.darkGray.cgColor
    }
}

extension BottomPanelViewController: BottomPageViewControllerDelegate {
    
    func setSection(withIndex: Int) {
        
        if let button = simpleButtonWithTag(withIndex) {
            
            turnOffButtonsSelection()
            button.isSelected = !button.isSelected
        }
    }
    
    func closeBottomPanel() {
        delegate?.closeBottomPanel()
    }
}
