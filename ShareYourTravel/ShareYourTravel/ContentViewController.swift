//
//  ContentViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 23/08/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - ContentViewController
class ContentViewController: BaseViewController {

    // MAKR: Properties
        // constant
    
    var isContentViewEditEnable: Bool = true
    var data: BoardData?
    var images: [UIImage]?
    
    // MARK: Outlets
    @IBOutlet weak var navigationView: MainNavigationView?
    @IBOutlet weak var contentView: ContentView?
    @IBOutlet weak var heightConstraintForNavigationView: NSLayoutConstraint?
    @IBOutlet weak var bottomButtonContainerView: UIView?
    @IBOutlet weak var bottomHandleView: CustomView?
    @IBOutlet weak var bottomSlideView: UIView?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
        initNavigationView()
        initViews()
        setData()
    }
    
    override func initVars() {
        setContentTextViewUserInteractionEnabled(at: isContentViewEditEnable)
        
    }
    
    func setContentTextViewUserInteractionEnabled(at isEnable: Bool) {
        contentView?.contentTextView?.isUserInteractionEnabled = isEnable
    }
    
    override func initNavigationView() {
        
        if let _ = navigationController {
            navigationView?.setLeftButton(title: "Back")
            bottomButtonContainerView?.isHidden = true
            bottomSlideView?.isHidden = true
            tabBarController?.tabBar.isHidden = true
        }
        else {
            navigationView?.setLeftButton(title: "Close")
            navigationView?.setRightButton(title: "Save")
        }
        
        navigationView?.setDividerColor(isWhite: false)
        navigationView?.setDivider(isDivider: true)
        navigationView?.delegate = self
    }
    
    func initViews() {
        bottomHandleView?.initCustomView(bgColor: .lightGray)
    }
    
    func setData() {
        contentView?.contentTextView?.text = data?.content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Action
        // Editor Area
    @IBAction func imageButtonAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Add Picture", message: "Choose Library", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Use Camera", style: .default) { (alertAction) in
            self.useImagePicker(sourceType: .camera)
        }
        let imagePickerAction = UIAlertAction(title: "Use Photos", style: .default) { (alertAction) in
            self.useImagePicker(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(imagePickerAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func useImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
}


// MARK: - ContentViewController: MainNavigationViewDelegate
extension ContentViewController {
    
    override func rightButtonClicked() {
        guard let content = contentView?.contentTextView?.text else {
            return
        }
        
        guard let userID = DataManager.sharedInstance().user?.id else {
            print("Error: ContentViewController - rightButtonClicked(SaveButton) => User doesn't exist")
            return
        }
        
        NetworkManager.uploadData(content: content, userID:userID, images: images) { (data) in
            
            performUIUpdatesOnMain {
                switch data {
                case "1":
                    self.alertAction(title: "Success", message: "Upload success", isJoinSuccess: true)
                case "-1":
                    self.alertAction(title: "Couldn't upload", message: "Please try again")
                default:
                    print("Error: JoinViewController - joinButtonAction => Result Error")
                }
            }
        }
    }
}


// MARK: - ContentViewController: UIImagePickerControllerDelegate
extension ContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Error: ContentViewController - imagePickerController => image doesn't exist")
            return
        }
        
        if images == nil {
            images = [UIImage]()
        }
        
        images?.append(image)
        
        contentView?.images = images
        contentView?.initCollectionView()
        
        dismiss(animated: true, completion: nil)
    }
}

