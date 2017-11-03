//
//  JoinViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 08/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// MARK: - JoinViewController
class JoinViewController: BaseViewController {
    
    // MARK: Properties
        // constant
    let joinStoryboardID = "JoinViewController"
    var isNextButton: Bool = true
    var id: String?
    
    // MARK: Outlets
    @IBOutlet weak var navigationView: MainNavigationView?
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var subTitleLabel: UILabel?
    
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var heightConstraintForEmailView: NSLayoutConstraint?
    
    @IBOutlet weak var fullNameTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var heightConstraintForNameNPasswordView: NSLayoutConstraint?
    
    @IBOutlet weak var imageView: UIImageView?
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationView()
        initViews()
    }
    
    override func initVars() {
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func initNavigationView() {
        if !isNextButton {
            navigationView?.setLeftButton(title: "Back")
        }
        
        navigationView?.setDividerColor(isWhite: false)
        navigationView?.setDivider(isDivider: true)
        navigationView?.delegate = self
    }
    
    func initViews() {
        switch isNextButton {
        case false:
            heightConstraintForEmailView?.constant = 0
            titleLabel?.text = "Name and assword"
            subTitleLabel?.text = "Add your name so that friends can find you."
        default:
            heightConstraintForNameNPasswordView?.constant = 0
            titleLabel?.text = "E-mail Address"
            subTitleLabel?.text = "Using your e-mail address can join our service."
        }
        
        view.layoutIfNeeded()
    }
    
    
    // MARK: Actions
    @IBAction func nextButtonAction(_ sender: Any) {
        
        guard let id = emailTextField?.text  else {
            print("Error: JoinViewController - nextButtonAction => textField Doesn't exist.")
            return
        }
        
        DispatchQueue.global().async {
            NetworkManager.checkUser(id: id, completionHandler: { (data) in
                
                
                performUIUpdatesOnMain {
                    switch data {
                    case "1":
                        self.pushView(id: id)
                    case "-1":
                        self.alertAction(title: "Couldn't use e-mail", message: "E-mail already used", isJoinSuccess: false)
                    default:
                        print("Error: JoinViewController - nextButtonAction => Result Error")
                    }
                }
            })
        }
        
    }
    
    @IBAction func joinButtonAction(_ sender: Any) {
        
        guard let id = id, let nickname = fullNameTextField?.text, let password = passwordTextField?.text  else {
            print("Error: JoinViewController - nextButtonAction => textField Doesn't exist.")
            return
        }
        
    
        doRegister(id: id, nickname: nickname, password: password, completionHandler: {
            
            try? Auth.auth().signOut()
            if let user = Auth.auth().currentUser {
//                DispatchQueue.global().async {
//                    NetworkManager.addUser(id: id, nickname: nickname, password: password, completionHandler: { (data) in
//
//                        UserDefaults.standard.set(true, forKey: kLoginUserDefaultKey)
//                        performUIUpdatesOnMain {
//                            switch data {
//                            case "1":
//                                try? Auth.auth().signOut()
//                                self.alertAction(title: "Success", message: "Now you can log in", isJoinSuccess: true)
//                            case "-1":
//                                self.alertAction(title: "Couldn't use nickname", message: "Nickname already used")
//                            default:
//                                print("Error: JoinViewController - joinButtonAction => Result Error")
//                            }
//                        }
//                    })
//                }
            }
        })
        
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    func pushView(id: String) {
        guard let joinVC = storyboard?.instantiateViewController(withIdentifier: joinStoryboardID) as? JoinViewController else {
            print("Error: JoinViewController - nextButtonAction => JoinViewController doesn't exist")
            return
        }
        joinVC.isNextButton = false
        joinVC.id = id
        
        navigationController?.pushViewController(joinVC, animated: true)
    }
}

extension JoinViewController {
    func doRegister(id: String, nickname: String, password: String, completionHandler: @escaping (Void)-> Void) {
        
        let email = id
        let name = nickname
        let password = password
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if let user = user {
                let uid = user.uid
                let ref = Database.database().reference()
                ref.child("users").child(uid).child("email").setValue(email)
                ref.child("users").child(uid).child("name").setValue(name)
                
                let storage = Storage.storage(url: "gs://diary-83dae.appspot.com/")
                
                if let image = self.imageView?.image {
                    if let newImage = UIImageJPEGRepresentation(image, 0.1) {
                        let imageUrl = "\(UUID().uuidString).jpg"
                        
                        storage.reference().child("profile_image").child(imageUrl).child(imageUrl).putData(newImage, metadata: nil, completion: { (metadata, error) in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                            
                            if let url = metadata?.downloadURL() {
                                ref.child("users").child(uid).child("profileUrl").setValue(url.absoluteString)
                            }
                            
                            
                            NetworkManager.addUser(id: id, nickname: nickname, password: password, completionHandler: { (data) in
                                
                                performUIUpdatesOnMain {
                                    switch data {
                                    case "1":
                                        completionHandler()
                                        self.alertAction(title: "Success", message: "Now you can log in", isJoinSuccess: true)
                                    case "-1":
                                        self.alertAction(title: "Couldn't use nickname", message: "Nickname already used")
                                    default:
                                        print("Error: JoinViewController - joinButtonAction => Result Error")
                                    }
                                }
                            })
                        })
                    }
                }
            }
        }
    }
}
