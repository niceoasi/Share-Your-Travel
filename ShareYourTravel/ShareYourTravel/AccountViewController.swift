//
//  AccountViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 06/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// MARK: - AccountViewController
class AccountViewController: BaseViewController {
    
    // MARK: Properties
        // constant
    let simpleTableViewCellID = "SimpleTableViewCell"
    
    var items = [[Any]]()
    
    // MARK: Outlets
    @IBOutlet weak var navigationView: MainNavigationView?
    @IBOutlet weak var listTabelView: UITableView?
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var profileNameLabel: UILabel?
    @IBOutlet weak var viewProfileLabel: UILabel?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
        initNavigationView()
        initNibs()
    }
    
    override func initVars() {
        guard let items = loadPlist() else {
            print("Error: AccountViewController - initVars => Couldn't init items")
            return
        }
        
        self.items = items
    }
    
    func loadPlist() -> [[Any]]? {
        guard let path = Bundle.main.path(forResource: "AccountSettings", ofType: "plist") else {
            print("Error: AccountViewController - loadPlist => AccountSettings Plist doesn't exist")
            return nil
        }
        
        let items = NSArray(contentsOf: URL(fileURLWithPath: path)) as? [[Any]]
        
        return items
    }
    
    override func initNavigationView() {
        navigationView?.setTitle(title: "Account")
        navigationView?.setDividerColor(isWhite: false)
        navigationView?.setDivider(isDivider: true)
        navigationView?.delegate = self
    }
    
    override func initNibs() {
        let simpleCellNib = UINib(nibName: simpleTableViewCellID, bundle: nil)
        listTabelView?.register(simpleCellNib, forCellReuseIdentifier: simpleTableViewCellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initIsLogin()
    }
    
    func initIsLogin() {
        
        isLogin = UserDefaults.standard.bool(forKey: kLoginUserDefaultKey)
        
        switch isLogin {
        case true:
            profileNameLabel?.text = DataManager.sharedInstance().user?.nickname
            viewProfileLabel?.isHidden = false
        default:
            profileNameLabel?.text = "Please log in"
            viewProfileLabel?.isHidden = true
        }
        
        listTabelView?.reloadData()
    }
    
    
    // MARK: Actions
    
    @IBAction func viewProfileButtonAction(_ sender: Any) {
        switch isLogin {
        case true:
            print("Now Log in Success")
            break
        default:
            performSegue(withIdentifier: kLoginSegueID, sender: nil)
            break
        }
    }
    
}

// MARK: - AccountViewController: UITableViewDataSource, UITableViewDelegate
extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 5:
            guard isLogin else {
                return items[section].count - 1
            }
        default:
            break
        }
        
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed(kDefaultHeaderViewNibName, owner: self, options: nil)?.first as? SimpleTableHeaderView
        
        var title = ""
        switch section {
        case 0:
            title = "Privacy"
        case 1:
            title = "Settings"
        case 2:
            title = "Terms and Polices"
        case 3:
            title = "Support"
        case 4:
            title = "About"
        default:
            break
        }
        
        headerView?.configureView(title: title)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = Bundle.main.loadNibNamed(kDefaultFooterViewNibName, owner: self, options: nil)?.first as? SimpleTableFooterView
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kDefaultHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kDefaultFooterViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kDefaultCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: simpleTableViewCellID) as? SimpleTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 2:
            if let array = items[indexPath.section][indexPath.row] as? Array<String> {
                let title = array[0]
                cell.setEntities(title: title)
            }
        default:
            if let title = items[indexPath.section][indexPath.row] as? String {
                cell.setEntities(title: title)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        switch (section, row) {
        case (5, 2):
            try? Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: kLoginUserDefaultKey)
            UserDefaults.standard.set(nil, forKey: kLoginUserIDKey)
            initIsLogin()
        default:
            break
        }
    }
}
