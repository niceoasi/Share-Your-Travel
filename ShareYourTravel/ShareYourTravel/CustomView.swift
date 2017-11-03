//
//  CustomView.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 07/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

class CustomView: UIView {

    func initCustomView(bgColor: UIColor) {
        backgroundColor = bgColor
        layer.cornerRadius = 3.0
        layer.masksToBounds = false
        layer.shadowColor = bgColor.withAlphaComponent(0.2).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.8
    }

}
