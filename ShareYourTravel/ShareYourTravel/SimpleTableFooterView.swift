//
//  SimpleTableFooterView.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 07/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

class SimpleTableFooterView: UITableViewHeaderFooterView {
    
    // MARK: Properties
        // constant
    @IBOutlet weak var footerTextLabel: UILabel?
    
    // MARK: Outlets
    
    // MARK: Init
    
    func initVars() {}
    
    func initTitleLabel() {
        footerTextLabel?.font = UIFont(name: kDefaultLightFont, size: 12.0)
        footerTextLabel?.textColor = .darkGray
    }
    
    func configureView(title: String) {
        footerTextLabel?.text = title
        
        initTitleLabel()
    }
}

