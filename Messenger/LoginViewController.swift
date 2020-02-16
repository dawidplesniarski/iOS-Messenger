//
//  LoginViewController.swift
//  Messenger
//
//  Created by Dawid on 16/02/2020.
//  Copyright © 2020 Dawid. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        let authUI  = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            return
        }
        authUI?.delegate = self
        
        let authViewController = authUI!.authViewController()
        
        present(authViewController, animated: true, completion: nil)
    }
    
}

extension LoginViewController : FUIAuthDelegate{
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            return
        }
        performSegue(withIdentifier: "goShoutbox", sender: self)
    }
}
