//
//  NotificationViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 06/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - NotificationViewController
class NotificationViewController: BaseViewController {
    
    // MARK: Properties
        // constant
    
    // MARK: Outlets
    @IBOutlet weak var navigationView: MainNavigationView?
    @IBOutlet weak var noticeLabel: UILabel?
    @IBOutlet weak var needLoginView: LoginRequiredUIView?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
        initNavigationView()
        initNoticeLabel()
    }
    
    override func initVars() {
        needLoginView?.delegate = self
    }
    
    override func initNavigationView() {
        navigationView?.setTitle(title: "Notification")
        navigationView?.setDividerColor(isWhite: false)
        navigationView?.setDivider(isDivider: true)
        navigationView?.delegate = self
    }
    
    func initNoticeLabel() {
        noticeLabel?.text = "No recent news"
        noticeLabel?.font = UIFont(name: kCopperplateBold, size: 30.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initNeedLoginView()
    }
    
    func initNeedLoginView() {
        needLoginView?.setViewStatus()
    }
    
    // MARK: Actions
}
