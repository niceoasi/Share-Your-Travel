//
//  Extensions.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 06/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alertAction(title: String, message: String, isJoinSuccess: Bool = false) {
        let alertAction = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        switch isJoinSuccess {
        case true:
            alertAction.addAction(okayAction)
        default:
            alertAction.addAction(cancelAction)
        }
        present(alertAction, animated: true, completion: nil)
    }
}
