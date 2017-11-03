//
//  MainNavigationView.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 06/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - MainNavigationViewDelegate
protocol MainNavigationViewDelegate: class {
    
    func leftButtonClicked()
    func rightButtonClicked()
    func titleAreaClicked()
}

// MARK: - MainNavigationView
class MainNavigationView: UIView {
    // MARK: Properties
    weak var delegate: MainNavigationViewDelegate?
    weak var containerView: UIView?
    
    // MARK: Outlets
    @IBOutlet weak var leftButton: UIButton?
    @IBOutlet weak var rightButton: UIButton?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var dividerImageView: UIImageView?
    @IBOutlet weak var titleArea: UIView?
    @IBOutlet weak var widthConstraintForRightButton: NSLayoutConstraint?
    @IBOutlet weak var widthConstraintForLeftButton: NSLayoutConstraint?
    @IBOutlet weak var textField: CustomTextField?
    
    
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
        containerView = Bundle.main.loadNibNamed("MainNavigationView", owner: self, options: nil)?.first as? UIView
        
        guard let containerView = containerView else {
            print("Error: MainNavigationView - commonInitialization => containerView doesn't exist")
            return
        }
        
        containerView.frame = bounds
        containerView.backgroundColor = kClearColor
        
        addSubview(containerView)
    }
    
    func initVars() {
        
    }
    
    func initBackgroundView() {
        
    }
    
    func initButtons() {
        leftButton?.isHidden = true
        rightButton?.isHidden = true
    }
    
    func initTitleLabel() {
        titleLabel?.font = UIFont(name: kDefaultBoldFont, size: 16.0)
        titleLabel?.textColor = .black
    }
    
    func initTextField() {
        textField?.isUserInteractionEnabled = true
        textField?.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
        initBackgroundView()
        initButtons()
        initTitleLabel()
        initTextField()
    }
    
    
    // MARK: setVars
    func setBGColor(color: UIColor) {
        containerView?.backgroundColor = color
    }
    
    func setTitle(title: String?) {
        titleLabel?.text = title
    }
    
    func setTitleColor(color: UIColor) {
        titleLabel?.textColor = color
    }
    
    func setTextField(userInterActionisEnable: Bool? = true) {
        if let userInterActionisEnable = userInterActionisEnable {
            textField?.isUserInteractionEnabled = userInterActionisEnable
        }
        
        textField?.isHidden = false
    }
    
    func setDividerColor(isWhite: Bool) {
        if isWhite {
            dividerImageView?.image = UIImage(named: "divider_w")
        }
        else {
            dividerImageView?.image = UIImage(named: "divider_b")
        }
    }

    func setDivider(isDivider: Bool) {
        dividerImageView?.isHidden = !isDivider
    }
    
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:)))
        titleArea?.addGestureRecognizer(tapGesture)
    }
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        delegate?.titleAreaClicked()
    }
    
    func setLeftButton(image: UIImage? = nil, color: UIColor? = .black, title: String? = "왼쪽") {
        leftButton?.isHidden = false
        leftButton?.setTitleColor(color, for: .normal)
        leftButton?.setTitle(title, for: .normal)
        leftButton?.titleLabel?.font = UIFont(name: kDefaultFont, size: 16.0)
        
        if let image = image {
            leftButton?.setImage(image, for: .normal)
        }
    }
    
    func setRightButton(image: UIImage? = nil, color: UIColor? = .black, title: String? = "오른쪽") {
        rightButton?.isHidden = false
        rightButton?.setTitleColor(color, for: .normal)
        rightButton?.setTitle(title, for: .normal)
        rightButton?.titleLabel?.font = UIFont(name: kDefaultFont, size: 16.0)
        
        if let image = image {
            rightButton?.setImage(image, for: .normal)
        }
    }
    
    func setRightButtonWidth(at width: CGFloat) {
        widthConstraintForRightButton?.constant = width
        layoutIfNeeded()
    }
    
    func setLeftButtonWidth(at width: CGFloat) {
        widthConstraintForLeftButton?.constant = width
        layoutIfNeeded()
    }
    
    
    // MARK: Actions
    @IBAction func leftButtonAction(_ sender: Any) {
        delegate?.leftButtonClicked()
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        delegate?.rightButtonClicked()
    }
    
    @IBAction func favoritButtonAction(_ sender: Any) {
    }
    
    @IBAction func mapButtonAction(_ sender: Any) {
    }
}



// MARK: MainNavigationViewDelegate - extension
extension MainNavigationViewDelegate {
    
    func leftButtonClicked() {}
    func rightButtonClicked() {}
    func titleAreaClicked() {}
}
 
