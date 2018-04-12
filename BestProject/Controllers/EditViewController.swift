//
//  EditViewController.swift
//  BestProject
//
//  Created by Alina on 4/12/18.
//  Copyright © 2018 a2b DesignLabs. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func savePressed(_ sender: UIButton) {
        let currentUser = Auth.auth().currentUser
        let userRef = Database.database().reference().child("user").child((currentUser?.uid)!)
        let id = currentUser?.uid
        let name = nameTextField.text
        let surname = surnameTextField.text
        let dateOfBirth = dateOfBirthTextField.text
        let user = [
            "id" : id,
            "name" : name,
            "surname" : surname,
            "dateOfBirth" : dateOfBirth,
            "e-mail": currentUser?.email
        ]
        
        userRef.setValue(user)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tweetsViewController") as! ProfileViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
