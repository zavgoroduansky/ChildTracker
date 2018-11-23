//
//  SwitcherView.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/13/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

protocol SegmentedViewDataSource: AnyObject {
    
    func numberOfSegments(_ segmentedControl: UISegmentedControl) -> Int
    
    func segmentTitle(_ segmentedControl: UISegmentedControl, atIndex: Int) -> String?
    func segmentImage(_ segmentedControl: UISegmentedControl, atIndex: Int) -> UIImage?
}

extension SegmentedViewDataSource {

    func segmentTitle(_ segmentedControl: UISegmentedControl, atIndex: Int) -> String? {
        return nil
    }

    func segmentImage(_ segmentedControl: UISegmentedControl, atIndex: Int) -> UIImage? {
        return nil
    }
}

protocol SegmentedViewDelegate: AnyObject {
    
    func didSelectSegmentIn(_ segmentedControl: UISegmentedControl, withIndex: Int)
}

extension SegmentedViewDelegate {
    
    func didSelectSegmentIn(_ segmentedControl: UISegmentedControl, withIndex: Int) {
        // empty body
    }
}

class SegmentedView: DesignableView {

    // MARK: Properties
    private weak var dataSource: SegmentedViewDataSource?
    private weak var delegate: SegmentedViewDelegate?
    
    // MARK: UI
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var detailLabel: UILabel!
    
    // MARK: Actions
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        delegate?.didSelectSegmentIn(segmentedControl, withIndex: segmentedControl.selectedSegmentIndex)
    }
    
    override func setup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        contentView = view
        
        // Add our border here and every custom setup
        contentView.backgroundColor = UIColor.lightGray
    }
    
    func setupView(dataSource: SegmentedViewDataSource?, delegate: SegmentedViewDelegate?) {
        
        self.dataSource = dataSource
        self.delegate = delegate
        
        segmentedControl.removeAllSegments()
        
        if let numberOfSegments = dataSource?.numberOfSegments(segmentedControl) {
            
            for index in 0...numberOfSegments {
                
                segmentedControl.insertSegment(withTitle: "", at: index, animated: false)
                
                if let title = dataSource?.segmentTitle(segmentedControl, atIndex: index) {
                    segmentedControl.setTitle(title, forSegmentAt: index)
                }
                
                if let image = dataSource?.segmentImage(segmentedControl, atIndex: index) {
                    segmentedControl.setImage(image, forSegmentAt: index)
                }
            }
        }
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func setSelectedSegment(_ segment: Int) {
        segmentedControl.selectedSegmentIndex = segment
    }
}
