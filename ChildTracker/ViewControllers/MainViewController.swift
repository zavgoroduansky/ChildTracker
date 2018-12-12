//
//  MainViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/8/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit
import Panels

class MainViewController: BaseViewController {

    // MARK: Properties
    public var presenter: MainViewControllerPresenter?
    // activity - is a current state at start of the app
    public var currentStateLine: StateLine = StateLine() {
        willSet {
            turnCurrentStateTo(stateLine: newValue)
        }
    }
    lazy var panelManager = Panels(target: self)
    var bottomPanel: BottomPanelViewController {
        let controller = UIStoryboard.instantiatePanel(identifier: "BottomPanel") as! BottomPanelViewController
        controller.delegate = self
        return controller
    }
    
    
    // MARK: UI
    @IBOutlet weak var locationSegmentedContainer: SegmentedView!
    @IBOutlet weak var statesContainer: UIView!
    @IBOutlet weak var currentStateBorderView: UIView!
    @IBOutlet weak var topStateContainer: StateButton!
    @IBOutlet weak var leftStateContainer: StateButton!
    @IBOutlet weak var rightStateContainer: StateButton!
    @IBOutlet weak var bottomStateContainer: StateButton!
    
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewElements()
        showFirstLaunchPageControl()
        
        var panelConfiguration = PanelConfiguration(size: .thirdQuarter)
        panelConfiguration.useSafeArea = true
        
        // To present the panel
        panelManager.show(panel: bottomPanel, config: panelConfiguration)
    }
}

// MARK: Public
extension MainViewController {

    func pauseResumeCurrentState() {
        
        if currentStateLine.state != .activity {
            let currentContainer = self.containerFromState(currentStateLine.state)
            currentContainer.setPlayPauseImageViewTo(currentContainer.buttonState() == .active ? .paused : .active)
        }
    }
    
    func updateContainers(_ stateLines: [StateLine]) {
        
        for stateLine in stateLines {
            // set detail text
            self.containerFromState(stateLine.state).setDetailText(prepareDetailTextFor(stateLine: stateLine))
            // set side
            if stateLine.state.showDetailViews() {
                self.containerFromState(stateLine.state).setSideView(stateLine.side)
            }
        }
    }
    
    func showSideChoosingView(completion: @escaping (Side?) -> Void) {
        
        let alert = UIAlertController(title: "Side", message: "Choose side", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Side.left.title(), style: .default, handler: { action in
            completion(Side.left)
        }))
        alert.addAction(UIAlertAction(title: Side.right.title(), style: .default, handler: { (action) in
            completion(Side.right)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            completion(nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateCurrentStateTimerText(_ text: String) {
        containerFromState(currentStateLine.state).setTimerText(text)
    }
}

// MARK: Private
private extension MainViewController {
    
    func prepareDetailTextFor(stateLine: StateLine) -> String {
        return "Last time \(FormatManager.formatDayDifference(for: stateLine.startDate)) for \(FormatManager.formatDurationForDetail(Int(stateLine.duration)))"
    }
    
    func containerFromState(_ state: State) -> StateButton {
        
        switch state {
        case .activity:
            return topStateContainer
        case .sleep:
            return rightStateContainer
        case .feeding:
            return bottomStateContainer
        case .bathing:
            return leftStateContainer
        }
    }
    
    func turnCurrentStateTo(stateLine: StateLine) {
        
        if stateLine != currentStateLine {
            // need to rotate
            UIView.animate(withDuration: 1, animations: { [unowned self] in
                let angle = self.calculateRotationAngleFor(stateLine.state)
                self.statesContainer.transform = self.statesContainer.transform.rotated(by: angle)
                self.rotateView(self.topStateContainer.contentView, toAngle: -angle)//rotateToAngle(-angle)
                self.topStateContainer.setTimerText("")
                self.topStateContainer.setPlayPauseImageViewTo(.finished)
                self.rotateView(self.leftStateContainer.contentView, toAngle: -angle)//rotateToAngle(-angle)
                self.leftStateContainer.setTimerText("")
                self.leftStateContainer.setPlayPauseImageViewTo(.finished)
                self.rotateView(self.rightStateContainer.contentView, toAngle: -angle)//rotateToAngle(-angle)
                self.rightStateContainer.setTimerText("")
                self.rightStateContainer.setPlayPauseImageViewTo(.finished)
                self.rotateView(self.bottomStateContainer.contentView, toAngle: -angle)//rotateToAngle(-angle)
                self.bottomStateContainer.setTimerText("")
                self.bottomStateContainer.setPlayPauseImageViewTo(.finished)
                
                if stateLine.state.showDetailViews() {
                    self.containerFromState(stateLine.state).setSideView(stateLine.side)
                }
                
                if stateLine.state != .activity {
                    self.containerFromState(stateLine.state).setPlayPauseImageViewTo(.active)
                }
            }) { (success) in
                // for something
            }
        }
    }
    
    func calculateRotationAngleFor(_ state: State) -> CGFloat {
        return CGFloat(Double(state.numberOfElementsTo(currentStateLine.state)) * 90 * Double.pi / 180) // number of elements * 90 degrees
    }
    
    func showFirstLaunchPageControl() {
        
        if UserDefaultManager.isThisFirstLaunch() {
            performSegue(withIdentifier: "firstLaunch", sender: self)
        }
    }
    
    func setupViewElements() {
        
        // init rotate animation
        statesContainer.transform = CGAffineTransform(rotationAngle: CGFloat(0 * Double.pi / 180))
        
        currentStateBorderView.layer.borderColor = UIColor.red.cgColor
        currentStateBorderView.layer.borderWidth = 5
        currentStateBorderView.layer.cornerRadius = currentStateBorderView.bounds.height / 2
        
        presenter?.setupLocationSegmentedContainer(locationSegmentedContainer)
        presenter?.setupStateContainer(topStateContainer, state: .activity, side: nil)
        presenter?.setupStateContainer(rightStateContainer, state: .sleep, side: nil)
        presenter?.setupStateContainer(bottomStateContainer, state: .feeding, side: nil)
        presenter?.setupStateContainer(leftStateContainer, state: .bathing, side: nil)
    }
}

extension MainViewController: BottomPanelViewControllerDelegate {
    
    var buttonsActionIsAvailable: Bool {
        return panelManager.isExpanded
    }
    
    func openBottomPanel() {
        panelManager.expandPanel()
    }
}

extension MainViewController: RotatableView { }
