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
    private let mainContainerView: UIView = UIView(frame: CGRect.zero)
    private let titleView: TitleView = TitleView(frame: CGRect.zero)
    private let tableView: UITableView! = UITableView(frame: CGRect.zero)
    private let buttonView: ButtonsView = ButtonsView(frame: CGRect.zero)
    
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.setFirstResponder(tableView)
    }
}

private extension AddNewActionViewController {
    
    @objc func tapGestureHandler(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupViewElements() {
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        
        tableView.tableFooterView = UIView()
        
        titleView.titleLabel.text = actionTitle
        
        mainContainerView.backgroundColor = UIColor.white
        mainContainerView.layer.cornerRadius = 10
        mainContainerView.clipsToBounds = true
        
        addGestureRecognizer()
        
        view.addSubview(mainContainerView)
        mainContainerView.addSubview(titleView)
        mainContainerView.addSubview(tableView)
        
        view.addSubview(buttonView)
        
        setupConstraints()
        
        presenter?.setupTableView(tableView)
        presenter?.setupButtonsPart(buttonView)
    }
    
    func addGestureRecognizer() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupConstraints() {
        
        mainContainerView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(UIScreen.main.bounds.height*0.5)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
        }
        
        titleView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        buttonView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(50)
            make.top.equalTo(mainContainerView.snp.bottom).offset(20)
        }
    }
}

extension AddNewActionViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let point = touch.location(in: view)
        return mainContainerView.frame.contains(point) ? false : true
    }
}
