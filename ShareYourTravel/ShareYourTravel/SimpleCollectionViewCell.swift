//
//  SimpleCollectionViewCell.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 04/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - SimpleCollectionViewCell
class SimpleCollectionViewCell: UICollectionViewCell {

    // MARK: Properties
    
    // MARK: Outlets
    @IBOutlet weak var thumbImageView: UIImageView?
    
    // MARK: Life Cycle
    func initVars() {
        clipsToBounds = true
        
    }
    
    func initBackgroundView() {
        
    }
    
    func initImageView() {
        thumbImageView?.contentMode = .scaleAspectFill
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
        initBackgroundView()
        initImageView()
    }

    
    
    // MARK: Set Entities
    func setEntities(image: UIImage) {
        
        thumbImageView?.image = image
    }
}
