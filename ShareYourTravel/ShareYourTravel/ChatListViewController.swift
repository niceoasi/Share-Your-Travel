//
//  ChatListViewController.swift
//  ShareYourTravel
//
//  Created by Daeyun Ethan Kim on 17/09/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

// MARK: - ChatListViewController
class ChatListViewController: BaseViewController {

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


// MARK: - ChatViewController:
extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
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
