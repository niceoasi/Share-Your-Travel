//
//  HomeViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 06/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - HomeViewController
class HomeViewController: BaseViewController {
    
    // MARK: Properties
        // constant
    
    // MARK: Outlets
    @IBOutlet weak var navigationView: MainNavigationView?
    @IBOutlet weak var needLoginView: LoginRequiredUIView?
    @IBOutlet weak var contentTableView: UITableView?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
        initBackgroundView()
        initNavigationView()
        initNibs()
    }
    
    override func initVars() {
        needLoginView?.delegate = self
    }
    
    override func initNavigationView() {
        navigationView?.setTitle(title: "Home")
        navigationView?.setDividerColor(isWhite: false)
        navigationView?.setDivider(isDivider: true)
        navigationView?.delegate = self
    }
    
    override func initNibs() {
        let homeTVCellNib = UINib(nibName: kHomeTableViewCellID, bundle: nil)
        contentTableView?.register(homeTVCellNib, forCellReuseIdentifier: kHomeTableViewCellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initNeeLoginView()
    }
    
    func initNeeLoginView() {
        needLoginView?.setViewStatus()
    }
    
    // MARK: Actions
}

// MARK: -
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataManager.sharedInstance().userContents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let boardData = DataManager.sharedInstance().userContents[indexPath.row]
        
        return ContentTableViewCell.getHeight(entity: boardData)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kHomeTableViewCellID, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        let data = DataManager.sharedInstance().userContents[indexPath.row]
        
        if let title = data.content, let  date = data.createTime {
            cell.setEntities(title: title, date: date)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = DataManager.sharedInstance().userContents[indexPath.row]
        
    }
    
}
