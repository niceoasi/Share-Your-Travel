//
//  CustomTabBarController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 06/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - CustomTabBarController
class CustomTabBarController: UITabBarController {

    // MAKR: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabbarColor()
        initTabbarVar()
    }
    
    func initTabbarVar() {
        selectedIndex = 1
    }
    
    func initTabbarColor() {
        tabBar.barTintColor = .black
        tabBar.tintColor = .red
        
    }
    
}
