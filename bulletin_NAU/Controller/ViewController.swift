//
//  ViewController.swift
//  bulletin_NAU
//
//  Created by Artificial Intelligence  on 12/5/17.
//  Copyright © 2017 bulletin_nau. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutHandle))
    }
    
    @objc func logoutHandle (){
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }

}

