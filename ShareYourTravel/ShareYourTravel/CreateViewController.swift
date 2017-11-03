//
//  CreateViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 06/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - CreateViewController
class CreateViewController: BaseViewController {
    
    // MARK: Properties
        // constant
    let contentViewSegueID = "ContentViewSegue"
    
    // MARK: Outlets
    @IBOutlet weak var navigationView: MainNavigationView?
    @IBOutlet weak var writeBackgroundView: CustomView?
    @IBOutlet weak var createBackgroundView: CustomView?
    @IBOutlet weak var needLoginView: LoginRequiredUIView?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
        initBackgroundView()
        initNavigationView()
        initBackgroundCardView()
    }
    
    override func initVars() {
        needLoginView?.delegate = self
    }
    
    override func initBackgroundView() {}
    
    override func initNavigationView() {
        navigationView?.setTitle(title: "Create")
        navigationView?.setDividerColor(isWhite: false)
        navigationView?.setDivider(isDivider: true)
        navigationView?.delegate = self
    }
    
    func initBackgroundCardView() {
        writeBackgroundView?.initCustomView(bgColor: .darkGray)
        createBackgroundView?.initCustomView(bgColor: .darkGray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initNeeLoginView()
    }
    
    func initNeeLoginView() {
        needLoginView?.setViewStatus()
    }
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            print("CreateViewController - prepare => identifier doesn't exist")
            return
        }
        
        let destinationVC = segue.destination as? ContentViewController
        
        switch segueID {
        case contentViewSegueID:
            destinationVC?.isContentViewEditEnable = true
            break
        default:
            print("Error: CreateViewController - prepare => segue doesn't exist")
            break
        }
    }
    
    // MARK: Actions
    @IBAction func writeSimplyButtonAction(_ sender: Any) {
        performSegue(withIdentifier: contentViewSegueID, sender: nil)
    }
}
