//
//  LoginRequiredUIView.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 09/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

protocol LoginRequiredUIViewDelegate: class {
    func login()
}


// MARK: LoginRequiredView
class LoginRequiredUIView: UIView {
    
    // MARK: Properties
        // constant
    weak var containerView: UIView?
    weak var delegate: LoginRequiredUIViewDelegate?
    
    // MARK: Outlets
    @IBOutlet weak var loginButton: UIButton?
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
    }
    
    func commonInitialization() {
        containerView = Bundle.main.loadNibNamed("LoginRequiredUIView", owner: self, options: nil)?.first as? UIView
        
        guard let containerView = containerView  else {
            print("Error: LoginRequiredUIView - commonInitialization => containerView doesn't exist")
            return
        }
        
        containerView.frame = bounds
        containerView.backgroundColor = kClearColor
        
        addSubview(containerView)
    }
    
    func initVars() {}
    
    func initBackgroundView() {
        
        backgroundColor = UIColor(hexString: "#F2F2F2")
    }
    
    func initButtons() {
        loginButton?.setTitle("Log in is required", for: .normal)
        loginButton?.titleLabel?.font = UIFont(name: kCopperplateBold, size: 30.0)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
        initBackgroundView()
        initButtons()
    }
    
    
    // MARK: SetVars
    func setViewStatus() {
        isHidden = isLogin ? true : false
    }
    
    // MARK: Actions
    @IBAction func loginButtonAction(_ sender: Any) {
        delegate?.login()
    }
}
