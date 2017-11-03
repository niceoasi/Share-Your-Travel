//
//  HomeTableViewCell.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 11/10/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    // MARK: Properties
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    
    
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
    func setEntities(title: String, date: String) {
        titleLabel?.text = title
        dateLabel?.text = date
    }
    
}
