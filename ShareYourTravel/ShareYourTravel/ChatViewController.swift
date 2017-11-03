//
//  ChatViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 17/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - ChatViewController
class ChatViewController: BaseViewController {

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

// MARK: - 
extension ChatViewController {
    func isMe() -> Bool {
        
        return true
    }
    
    func isNotMe() -> Bool {
        
        return true
    }
    
    func keyboardWillShow() {
        
    }
    
    func keyboardWillHide() {
        
    }
}


// MARK: - ChatViewController: 
extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kSimpleTableViewCellID, for: indexPath) as? SimpleTableViewCell else {
            
            return UITableViewCell()
        }
        
        
        return cell
    }
}
