//
//  ProfileViewController.swift
//  BestProject
//
//  Created by Alina on 4/10/18.
//  Copyright © 2018 a2b DesignLabs. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    let tweetRef = Database.database().reference().child("tweets")
    var tweets = [Tweet]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tweetRef.observe(.value, with: {(snapshot) in
            self.tweets.removeAll()
            
            for child in snapshot.children{
                let childSnapshot = child as! DataSnapshot
                let tweet = Tweet(snapshot: childSnapshot)
                self.tweets.insert(tweet, at: 0)
                
            }
            self.tableView.reloadData()
        })
        
    }
    
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let signOutBtn = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
        self.navigationItem.rightBarButtonItem = signOutBtn
        guard let user = Auth.auth().currentUser?.displayName else{ return }
        self.navigationItem.title = user
        
        let addButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: self.view.frame.height - 100), size: CGSize(width: 80, height: 80)))
        let addImage = UIImage(named: "add.png")
        addButton.setImage(addImage, for: .normal)
        addButton.addTarget(self, action: #selector(addTweet), for: .touchUpInside)
        self.navigationController?.view.addSubview(addButton)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    @objc func addTweet(){
        createTweetAlert()
    }
    
    
    @objc func signOut(){
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "signOutSegue", sender: nil)
        } catch{
            print(error)
        }
    }
    
    func createTweetAlert(){
        let alertController = UIAlertController(title: "Add New Tweet", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Your tweet here"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let tweetTextField = alertController.textFields![0] as UITextField
            let hashtagTextField = alertController.textFields![1] as UITextField
            
            
            let currentUserEmail = Auth.auth().currentUser?.email
            let newTweet = Tweet(tweetTextField.text!, currentUserEmail!, hashtagTextField.text!)
            newTweet.save()
            /*let queryRef = Database.database().reference().child("users")
            queryRef.child((Auth.auth().currentUser?.uid)!).observe(.value, with: {(snapshot) -> Void in
                if let usersDictionary = snapshot.value as? [String:Any] {
                    let currentUserName = usersDictionary["name"] as? String ?? ""
                    let newTweet = Tweet(tweetTextField.text!, currentUserName, hashtagTextField.text!)
                    newTweet.save()
                    print("Success!\(currentUserName)")
                }
                
        })*/
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Hashtag place"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}
