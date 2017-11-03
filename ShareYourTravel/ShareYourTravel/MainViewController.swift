//
//  MainViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 23/08/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// MARK: - MainViewController
class MainViewController: BaseViewController {

    // MARK: Properties
        // constant
    let contentTableViewCellID = "ContentTableViewCell"
    let showContentSegueID = "ShowContentSegue"
    var hadle: AuthStateDidChangeListenerHandle?
    
    // MARK: Outlets
    @IBOutlet weak var navigationView: MainNavigationView?
    @IBOutlet weak var contentTableView: UITableView?
    @IBOutlet weak var tableViewHeaderView: UIView?
    @IBOutlet weak var heightConstraintForHeaderView: NSLayoutConstraint?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
        initBackgroundView()
        initNavigationView()
        initNibs()
        initTableView()
    }
    
    override func initVars() {
        isLogin = UserDefaults.standard.bool(forKey: kLoginUserDefaultKey)
        view.layoutIfNeeded()
    }
    
    override func initNavigationView() {
        navigationView?.setTitle(title: "Travel")
        navigationView?.setDividerColor(isWhite: false)
        navigationView?.setDivider(isDivider: true)
        navigationView?.delegate = self
    }
    
    override func initNibs() {
        let contentTableViewCellNib = UINib(nibName: contentTableViewCellID, bundle: nil)
        contentTableView?.register(contentTableViewCellNib, forCellReuseIdentifier: contentTableViewCellID)
    }
    
    func initTableView() {
        contentTableView?.contentInset = UIEdgeInsets(top: (tableViewHeaderView?.frame.height)!, left: 0.0, bottom: 0.0, right: 0.0)
        contentTableView?.contentOffset = CGPoint(x:0 , y: -200)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hadle = Auth.auth().addStateDidChangeListener({ (auth, user) in
        })
        
        if let user = Auth.auth().currentUser {
            // 테스트
        } else {
        }
        
//        setDummy()
        updataData()
        contentTableView?.reloadData()
        
    }

    func updataData() {
        DispatchQueue.global().async { () -> Void in
            NetworkManager.updateBoardData(completionHandler: { (datas) in
                DataManager.sharedInstance().contents = datas
                
                for (index, value) in datas.enumerated() {
                        NetworkManager.getImagePath(boardID: value.id, completionHandler: { (paths) in
                            DataManager.sharedInstance().contents[index].imageURLs = paths
                    })
                }
                
                performUIUpdatesOnMain {
                    self.contentTableView?.reloadData()
                }
            })
        }
        
        if UserDefaults.standard.string(forKey: kLoginUserIDKey) == nil {
            return
        }
        
        DispatchQueue.global().async {
            NetworkManager.getUserData(completionHandler: { (data) in
                DataManager.sharedInstance().user = data
                performUIUpdatesOnMain {
                }
            })
        }
    }
    
    func setDummy() {
//        DataManager.sharedInstance().initDummyList()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateHeaderView()
    }
    
    func updateHeaderView() {
        
        guard let contentTableView = contentTableView,  let tableViewHeaderView = tableViewHeaderView,
            let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView else {
            print("Error: MainViewController - updateHeaderView => tableView doesn't exist")
            return
        }
        
        var headerRect = CGRect(x: 0, y: -200, width: contentTableView.frame.width, height: 200)
        let contentOffSetY = contentTableView.contentOffset.y
        
        
        if contentOffSetY <= -20 {
            headerRect.origin.y = -200 + contentOffSetY
            headerRect.size.height = 200 - contentOffSetY
        }
        else {
            headerRect.origin.y = -200 + contentOffSetY
            headerRect.size.height = 200 - contentOffSetY
        }
        
        if contentOffSetY > -20 {
            tableViewHeaderView.alpha = (100 - contentOffSetY)/100
            
            if contentOffSetY <= 100 {
                navigationView?.alpha = contentOffSetY/100
            }
            
            let color = 255 - ((100 + contentOffSetY)/100 * 255)
            navigationItem.leftBarButtonItem?.tintColor = UIColor.init(red: color/255, green: color/255, blue: color/255, alpha: 1.0)
            
            
            statusBar.setValue(UIColor.init(red: color/255, green: color/255, blue: color/255, alpha: 1.0), forKey: "foregroundColor")
        }
        else {
            
            tableViewHeaderView.alpha = 1
            navigationView?.alpha = 0
            navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            statusBar.setValue(UIColor.white, forKey: "foregroundColor")
        }
        
        tableViewHeaderView.frame = headerRect
    }
    
    
    // MARK: Action
    @IBAction func addContentAction(_ sender: Any) {
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ContentViewController
        
        guard let segueID = segue.identifier else {
            print("ViewController - identifier doesn't exist")
            return
        }
        
        switch segueID {
        case showContentSegueID:
            destinationVC?.data = sender as? BoardData
            destinationVC?.isContentViewEditEnable = false
            
        default:
            print("Error: ViewController - Segue doesn't exist")
            break
        }
    }
}


// MARK: - MainViewController: UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataManager.sharedInstance().contents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let boardData = DataManager.sharedInstance().contents[indexPath.row]
        
        return ContentTableViewCell.getHeight(entity: boardData)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: contentTableViewCellID, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        var data = DataManager.sharedInstance().contents[indexPath.row]
        
        NetworkManager.getImagePath(boardID: data.id) { (paths) in
            DataManager.sharedInstance().contents[indexPath.row].imageURLs = paths
            data.imageURLs = paths
            
            performUIUpdatesOnMain {
                
                cell.setEntities(data: data)
                cell.imageCollectionView?.reloadData()
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = DataManager.sharedInstance().contents[indexPath.row]
        performSegue(withIdentifier: showContentSegueID, sender: data)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}

