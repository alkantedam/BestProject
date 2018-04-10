//
//  ProfileViewController.swift
//  BestProject
//
//  Created by Alina on 4/10/18.
//  Copyright © 2018 a2b DesignLabs. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let signOutBtn = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
        self.navigationItem.rightBarButtonItem = signOutBtn
        guard let user = Auth.auth().currentUser?.displayName else{ return }
        self.navigationItem.title = user
    }

    
    @objc func signOut(){
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "signOutSegue", sender: nil)
        } catch{
            print(error)
        }
    }

}
