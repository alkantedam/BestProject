//
//  ProfileViewController.swift
//  BestProject
//
//  Created by Alina on 4/10/18.
//  Copyright © 2018 a2b DesignLabs. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //Creationg outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //Creating variables
    
    let tweetRef = Database.database().reference().child("tweets")
    var tweets = [Tweet]()
    var currentTweets = [Tweet]()
    
    //Appear functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        guard let user = Auth.auth().currentUser?.displayName else{ return }
        self.navigationItem.title = user
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        var items = [UIBarButtonItem]()
        self.navigationController?.setToolbarHidden(false, animated: animated)
        let signOutBtn = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
        let addTweetBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTweet))
        let showProfileBtn = UIBarButtonItem(title: "My Profile", style: .plain, target: self, action: #selector(editProfile))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        items.append(signOutBtn)
        items.append(flexibleSpace)
        items.append(addTweetBtn)
        items.append(flexibleSpace)
        items.append(showProfileBtn)
        self.toolbarItems = items
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.setToolbarHidden(false, animated: animated)
        tweetRef.observe(.value, with: {(snapshot) in
            self.tweets.removeAll()
            
            for child in snapshot.children{
                let childSnapshot = child as! DataSnapshot
                let tweet = Tweet(snapshot: childSnapshot)
                self.tweets.insert(tweet, at: 0)
            }
            self.currentTweets = self.tweets
            self.tableView.reloadData()
        })
        
    }
    
    //TableView functions
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = currentTweets[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let tweetForDeletion = currentTweets[indexPath.row]
        let currentUserEmail = Auth.auth().currentUser?.email
        if editingStyle == .delete{
            if currentUserEmail == tweetForDeletion.author{
                let id = tweetForDeletion.id
                tweetRef.child(id).setValue(nil)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: "You can't delete other users' tweets", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction!) -> Void in })
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    //Creating tweet

    func createTweetAlert(){
        let alertController = UIAlertController(title: "Add New Tweet", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Your tweet here"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let tweetTextField = alertController.textFields![0] as UITextField
            let hashtagTextField = alertController.textFields![1] as UITextField
            
            
            let currentUserEmail = Auth.auth().currentUser?.email
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let currentDate = formatter.string(from: date)
            
            let newTweet = Tweet(tweetTextField.text!, currentUserEmail!, hashtagTextField.text!, currentDate)
            newTweet.save()
            
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

    @objc func addTweet(){
        createTweetAlert()
    }
    
    //Sign out
    
    @objc func signOut(){
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "signOutSegue", sender: nil)
        } catch{
            print(error)
        }
    }
    
    //Edit profile
    
    @objc func editProfile(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "editViewController") as! EditViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    //Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else{
            currentTweets = tweets
            tableView.reloadData()
            return
        }
        currentTweets = tweets.filter({ (tweet) -> Bool in
            return tweet.hashtag.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

}
