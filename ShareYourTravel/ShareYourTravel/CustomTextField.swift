//
//  CustomTextField.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 20/08/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Border
        layer.cornerRadius = 1
        layer.borderWidth = 1.5
        layer.borderColor = UIColor(hexString: "#EBEBEB").cgColor
        
        //Background
        backgroundColor = UIColor(hexString: "#F7F7F7")
        
        //Text
        textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
