//
//  DatePickerTableViewCell.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/12/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    static let identifier = "DatePicker"
    static let normalHeight: CGFloat = 120
    
    public var valueChangedHandler: ((Date) -> Void)?
    
    // MARK: UI
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePickerValueChangedAction(_ sender: UIDatePicker) {
        valueChangedHandler?(sender.date)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
