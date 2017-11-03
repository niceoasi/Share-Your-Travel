//
//  SimpleTableHeaderView.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 07/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

class SimpleTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Properties
        // constant
    @IBOutlet weak var headerTitleLabel: UILabel?
    
    // MARK: Outlets
    
    // MARK: Init
    
    func initVars() {}
    
    func initTitleLabel() {
        headerTitleLabel?.font = UIFont(name: kDefaultFont, size: 14.0)
        headerTitleLabel?.textColor = .darkGray
    }
    
    func configureView(title: String) {
        headerTitleLabel?.text = title
        
        initTitleLabel()
    }
}
