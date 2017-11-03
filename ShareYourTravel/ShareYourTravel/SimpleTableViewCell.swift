//
//  SimpleTableViewCell.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 06/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel?
    
    
    // MARK: Life Cycle
    func initVars() {
        clipsToBounds = true
    }
    
    func initBackgroundView() {
        
    }

    func initTitleLabel() {
        titleLabel?.font = UIFont(name: kAppleSDGothicNeoRegularFont, size: 16.0)
        titleLabel?.textColor = .black
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
        initBackgroundView()
        initTitleLabel()
    }
    
    
    // MARK: Set Entities
    func setEntities(title: String) {
        titleLabel?.text = title
    }
}
