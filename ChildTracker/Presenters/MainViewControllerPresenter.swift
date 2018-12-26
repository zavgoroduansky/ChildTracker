//
//  MainViewControllerPresenter.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/13/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

class MainViewControllerPresenter: NSObject {

    // MARK: Properties
    public weak var viewController: MainViewController?
    public var activityManager: ActivityManager?
}

// MARK: Public
extension MainViewControllerPresenter {
    
    func setupChildInfoContainer(_ container: ChildInfoView) {
        
        container.mainImageView.image = ChildManager.child.photo
        container.childNameLabel.text = ChildManager.child.name
        container.childAgeLabel.text = ChildManager.child.age
        container.setImageHandler = { [unowned self = self] (sender) in
            
            if UserDefaultManager.fetchUserData() != nil {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                self.viewController?.show(imagePicker, sender: self)
            } else {
                self.viewController?.showInfoView(title: "Error", text: "Use need set user data firstly")
            }
        }
    }
    
    func setupLocationSegmentedContainer(_ container: SegmentedView) {
        
        container.setupView(dataSource: self, delegate: self)
    }
    
    func setupStateContainer(_ container: StateButton, state: State, side: Side?) {
        
        container.initButtonWith(tag: state.rawValue, title: state.title(), showDetailViews: state.showDetailViews()) { [unowned self] (sender) in
            if let selectedState = State.init(rawValue: sender.tag) {
                if selectedState != self.activityManager?.currentStateLine.state, let previousStateLine = self.viewController?.currentStateLine {
                    self.viewController?.currentStateLine = StateLine(state: state, startDate: Date(), duration: 0, side: nil, condition: .finished)
                    // need to switch to new state
                    if selectedState.showDetailViews() {
                        self.viewController?.showSideChoosingView(completion: { (side) in
                            if let selectedSide = side {
                                self.switchToState(selectedState, side: selectedSide)
                            } else {
                                // cancel operation
                                self.viewController?.currentStateLine = previousStateLine
                            }
                        })
                    } else {
                        self.switchToState(selectedState, side: nil)
                    }
                } else if state != State.activity {
                    // need to pause/resume current state
                    if let opositCondition = self.activityManager?.currentStateLine.condition.opositCondition() {
                        self.viewController?.pauseResumeCurrentState()
                        self.activityManager?.currentStateLine.condition = opositCondition
                    }
                }
            }
        }
    }
}

// MARK: ActivityManagerDelegate
extension MainViewControllerPresenter: ActivityManagerDelegate {
    
    func setLocation(_ location: Location) {
        viewController?.locationSegmentedContainer.setSelectedSegment(location.rawValue)
    }
    
    func setStateLine(_ stateLine: StateLine) {
        viewController?.currentStateLine = stateLine
    }
    
    func updateDetailedStateLines(_ stateLines: [StateLine]) {
        viewController?.updateContainers(stateLines)
    }
    
    func locationTimerTick() {
        
        if let duration = activityManager?.locationTimerDuration {
            viewController?.locationSegmentedContainer.detailLabel.text = FormatManager.formatDurationForTimer(duration)
        }
    }
    
    func stateTimerTick() {
        
        if let duration = activityManager?.stateTimerDuration {
            viewController?.updateCurrentStateTimerText(FormatManager.formatDurationForTimer(duration))
        }
    }
}

// MARK: SegmentedViewDataSource
extension MainViewControllerPresenter: SegmentedViewDataSource {
    
    func numberOfSegments(_ segmentedControl: UISegmentedControl) -> Int {
        return 1
    }
    
    func segmentTitle(_ segmentedControl: UISegmentedControl, atIndex: Int) -> String? {
        
        if let location = Location.init(rawValue: atIndex) {
            return location.title()
        } else {
            return ""
        }
    }
}

// MARK: SegmentedViewDelegate
extension MainViewControllerPresenter: SegmentedViewDelegate {

    func didSelectSegmentIn(_ segmentedControl: UISegmentedControl, withIndex: Int) {
        
        if let location = Location.init(rawValue: withIndex) {
            viewController?.locationSegmentedContainer.detailLabel.text = ""
            activityManager?.location = location
        }
    }
}

// MARK: Private
private extension MainViewControllerPresenter {
    
    func switchToState(_ state: State, side: Side?) {
        
        self.viewController?.currentStateLine = StateLine(state: state, startDate: Date(), duration: 0, side: side, condition: .active)
        self.activityManager?.currentStateLine = StateLine(state: state, startDate: Date(), duration: 0, side: side, condition: .active)
    }
}

extension MainViewControllerPresenter: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // need to save image to user defaults
            UserDefaultManager.saveUserImage(image)
            viewController?.newImageWasSelected(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MainViewControllerPresenter: UINavigationControllerDelegate {
    
    
}
