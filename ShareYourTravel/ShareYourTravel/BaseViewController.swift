//
//  BaseViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 23/08/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - BaseViewController
class BaseViewController: UIViewController {
    
    // MARK: Properties
        // constant
    weak var navigationBarView: MainNavigationView?
    
    // MARK: Outlets
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
        initBackgroundView()
        initNavigationView()
        initNibs()
    }
    
    func initVars() {}
    
    func initBackgroundView() {}
    
    func initNavigationView() {}
    
    func initNibs() {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Actions
}

// MARK:
extension BaseViewController: MainNavigationViewDelegate {
    func leftButtonClicked() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func rightButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController: LoginRequiredUIViewDelegate {
    func login() {
        performSegue(withIdentifier: kLoginSegueID, sender: nil)
    }
}
