//
//  InitialViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/7/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class InitialViewController: IntroPageBaseViewController {

    // MARK: Properties
    private var isFinished = false
    
    // MARK: UI
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var growthTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepareChildStruct() -> Child? {
        
        isFinished = true
        
        let name = nameTextField.checkName()
        if name == nil {
            nameTextField.shakeView()
            isFinished = false
        }
        
        let growth = growthTextField.checkName()
        if growth == nil {
            growthTextField.shakeView()
            isFinished = false
        }
        
        let weight = weightTextField.checkName()
        if weight == nil {
            weightTextField.shakeView()
            isFinished = false
        }
        
        return isFinished ? Child(name: name!, birthday: birthdayDatePicker.date, growth: growth!, weight: weight!) : nil
    }
}

extension InitialViewController: IntroPageViewControllersProtocol {
    
    var completed: Bool {
        return isFinished
    }
    
    var orderNumber: Int {
        return 1;
    }
}
