//
//  LoginViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 03/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// MARK: - LoginViewController
class LoginViewController: BaseViewController {
    
    // MARK: Properties
    // constant
    let joinSegueID = "JoinSegue"
    let joinVCID = "Join"
    
    // MARK: Outlets
    @IBOutlet weak var navigationView: MainNavigationView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var userIDTextField: UITextField?
    @IBOutlet weak var userPasswordTextField: UITextField?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationView()
        initTitleLabel()
    }
    
    override func initNavigationView() {
        navigationView?.setRightButton(title: "Cancel")
        navigationView?.setDividerColor(isWhite: false)
        navigationView?.setDivider(isDivider: true)
        navigationView?.delegate = self
    }
    
    func initTitleLabel() {
        titleLabel?.font = UIFont(name: kCopperplateBold, size: 40.0)
        titleLabel?.textColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let id = UserDefaults.standard.string(forKey: kLoginUserIDKey) else {
            return
        }
    }
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            print("LoginViewController - prepare => segueID doesn't exist")
            return
        }
        
        switch segueID {
        case joinSegueID:
            guard let joinVC = storyboard?.instantiateViewController(withIdentifier: joinVCID) as? JoinViewController else {
                print("Error: LoginViewController - prepare => JoinViewController doesn't exist")
                return
            }
            let joinNC = UINavigationController(rootViewController: joinVC)
            
            present(joinNC, animated: true, completion: nil)
        default:
            break
        }
        
    }
    
    
    // MARK: Actions
    @IBAction func loginButtonAction(_ sender: Any) {
        
        guard let id = userIDTextField?.text, let password = userPasswordTextField?.text else {
            print("Error: LoginViewController - loginButtonAction => textField Doesn't exist.")
            
            return
        }
        
//        if let _ = Auth.auth().currentUser {
//            UserDefaults.standard.set(true, forKey: kLoginUserDefaultKey)
//            dismiss(animated: true, completion: nil)
//        }
        
        DispatchQueue.global().async {
            
            self.doLogin(id: id, password: password, completionHandler: { (email) in
                NetworkManager.login(id: email, completionHandler: { (userData) in
                    guard let userData = userData else {
                        let alertAction = UIAlertController(title: "Couldn't log in", message: "Please check your id and password", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                        alertAction.addAction(cancelAction)
                        
                        self.present(alertAction, animated: true, completion: nil)
                        
                        return
                    }
                    
                    
                    performUIUpdatesOnMain {
                        UserDefaults.standard.set(userData.id, forKey: kLoginUserIDKey)
                        UserDefaults.standard.set(true, forKey: kLoginUserDefaultKey)
                        isLogin = UserDefaults.standard.bool(forKey: kLoginUserDefaultKey)
                        
                        DataManager.sharedInstance().user = userData
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            })
        }
    }
    
    @IBAction func joinButtonAction(_ sender: Any) {
        performSegue(withIdentifier: joinSegueID, sender: nil)
    }
}

// MARK: - LoginViewController
extension LoginViewController {
    func doLogin(id: String, password: String, completionHandler: @escaping (String) -> Void) {
        let email = id
        let password = password
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let user = user {
                let uid = user.uid
                let ref = Database.database().reference()
                _ = ref.child("users").child(uid).observe(.value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let email = value?["email"] as? String ?? ""
    
                    completionHandler(email)
                })
            }
        }
    }
}
