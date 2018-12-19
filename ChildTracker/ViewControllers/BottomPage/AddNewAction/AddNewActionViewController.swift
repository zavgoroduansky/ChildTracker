//
//  AddNewActionViewController.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/12/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit
import SnapKit

class AddNewActionViewController: BaseViewController {

    // MARK: Properties
    public var presenter: AddNewActionViewControllerPresenter?
    public var actionTitle: String?
    
    // MARK: UI
    private var mainContainerView: UIView  = UIView(frame: CGRect.zero)
    private let titleLabel: UILabel = UILabel(frame: CGRect.zero)
    private let tableView: UITableView! = UITableView(frame: CGRect.zero)
    
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewElements()
    }
}

private extension AddNewActionViewController {
    
    @objc func tapGestureHandler(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupViewElements() {
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        titleLabel.textColor = UIColor.red
        titleLabel.text = actionTitle
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textAlignment = .center
        
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        
        mainContainerView.backgroundColor = UIColor.white
        mainContainerView.layer.cornerRadius = 10
        mainContainerView.clipsToBounds = true
        
        addGestureRecognizer()
        
        view.addSubview(titleLabel)
        view.addSubview(mainContainerView)
        mainContainerView.addSubview(tableView)
        
        setupConstraints()
        
        presenter?.setupTableView(tableView)
    }
    
    func addGestureRecognizer() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupConstraints() {
        
        mainContainerView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(550)
            make.left.equalToSuperview().offset(50)
            make.right.bottom.equalToSuperview().offset(-50)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalTo(mainContainerView.snp.top).offset(-10)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
}

extension AddNewActionViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let point = touch.location(in: view)
        return mainContainerView.frame.contains(point) ? false : true
    }
}
