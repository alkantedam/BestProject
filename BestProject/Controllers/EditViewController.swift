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
        getData()
        // Do any additional setup after loading the view.
    }
    
    func getData(){
        let currentUserId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("user").child(currentUserId!)
        _ = ref.observe(DataEventType.value, with: {
            (snapshot) in
            let infoDict = snapshot.value as! [String: Any]
            self.nameTextField.text = infoDict["name"] as? String
            self.nameTextField.becomeFirstResponder()
            self.nameTextField.selectedTextRange = self.nameTextField.textRange(from: self.nameTextField.beginningOfDocument, to: self.nameTextField.endOfDocument)
            self.surnameTextField.text = infoDict["surname"] as? String
            
            self.dateOfBirthTextField.text = infoDict["dateOfBirth"] as? String
            
         })
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
        
        /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tweetsViewController") as! ProfileViewController
        self.present(nextViewController, animated:true, completion:nil)
 */
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    


    

}
