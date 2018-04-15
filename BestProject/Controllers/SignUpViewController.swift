//
//  SignUpViewController.swift
//  BestProject
//
//  Created by Alina on 4/10/18.
//  Copyright © 2018 a2b DesignLabs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var sEmailTextField: UITextField!
    @IBOutlet weak var sPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        sPasswordTextField.isSecureTextEntry = true
    }
   

    
    @IBAction func signupPressed(_ sender: UIButton) {
        guard let name = nameTextField.text,
        name != "",
        let surname = surnameTextField.text,
        surname != "",
        let dateOfBirth = dateOfBirthTextField.text,
        dateOfBirth != "",
        let email = sEmailTextField.text,
        email != "",
        let password = sPasswordTextField.text,
        password != ""
            else {
                let alert = UIAlertController(title: "Error", message: "Fill all the fields", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                let userInfo = ["id" : user?.uid,
                                "e-mail" : email,
                                "name" : name,
                                "surname" : surname,
                                "dateOfBirth" : dateOfBirth]
                let ref = Database.database().reference()
                ref.child("user").child(user!.uid).setValue(userInfo)
            }
            else{
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard let user = user else{ return }
            
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges(completion: { (error) in
                guard error == nil else{
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.performSegue(withIdentifier: "signupSegue", sender: nil)
            })
            
        }    }
    
    

}
