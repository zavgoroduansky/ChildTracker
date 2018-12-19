//
//  BasicOpenableTableViewCell.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/13/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class BasicOpenableTableViewCell: UITableViewCell {

    static let identifier = "BasicOpenable"
    static let normalHeight: CGFloat = 50
    
    // MARK: UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stateImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
