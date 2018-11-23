//
//  StateButton.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/9/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class StateButton: DesignableButton {

    // MARK: Properties
    private var showDetailViews: Bool = false
    private var buttonCurrentState: Condition = .finished
    
    // MARK: UI
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var leftDetailView: UIView!
    @IBOutlet weak var rightDetailView: UIView!
    @IBOutlet weak var playPauseImageView: UIImageView!
    
    override func setup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        contentView = view
        
        // Add our border here and every custom setup
        backgroundColor = UIColor.clear
        
        contentView.backgroundColor = UIColor.blue
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = bounds.height / 2
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.masksToBounds = false
        contentView.layer.shadowRadius = 1.0
        contentView.layer.shadowOpacity = 0.5
        
        stateLabel.textColor = UIColor.yellow
        
        leftDetailView.layer.cornerRadius = leftDetailView.bounds.height / 2
        rightDetailView.layer.cornerRadius = leftDetailView.bounds.height / 2
        
        playPauseImageView.isHidden = true
    }
    
    func initButtonWith(tag: Int, title: String?, showDetailViews: Bool, handler: ((UIButton) -> ())?) {
        super.initButtonWith(tag: tag, handler: handler)
        
        self.showDetailViews = showDetailViews
        
        stateLabel.text = title
        leftDetailView.isHidden = !showDetailViews
        rightDetailView.isHidden = !showDetailViews
    }
    
    func setDetailText(_ text: String) {
        durationLabel.text = text
    }
    
    func setDetailView(_ side: Side?) {
        
        leftDetailView.backgroundColor = UIColor.lightGray
        rightDetailView.backgroundColor = UIColor.lightGray
        
        if let existedSide = side {
            switch existedSide {
            case .left:
                leftDetailView.backgroundColor = UIColor.red
            case .right:
                rightDetailView.backgroundColor = UIColor.red
            }
        }
    }
    
    func setPlayPauseImageViewTo(_ state: Condition) {
        
        buttonCurrentState = state
        
        switch state {
        case .finished:
            playPauseImageView.isHidden = true
        case .active:
            playPauseImageView.isHidden = false
            playPauseImageView.image = UIImage(named: "pause")
        case .paused:
            playPauseImageView.isHidden = false
            playPauseImageView.image = UIImage(named: "play")
        }
    }
    
    func buttonState() -> Condition {
        return buttonCurrentState
    }
}
