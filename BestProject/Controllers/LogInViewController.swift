//
//  LogInViewController.swift
//  BestProject
//
//  Created by Alina on 4/10/18.
//  Copyright © 2018 a2b DesignLabs. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var lEmailTextField: UITextField!
    
    @IBOutlet weak var lPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        lPasswordTextField.isSecureTextEntry = true
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = lEmailTextField.text,
        email != "",
        let password = lPasswordTextField.text,
        password != ""
            else{
                let alert = UIAlertController(title: "Error", message: "Fill all fields", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else{
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }
    }
    
    
}
