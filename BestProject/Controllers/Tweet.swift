//
//  Tweet.swift
//  BestProject
//
//  Created by Alina on 4/11/18.
//  Copyright © 2018 a2b DesignLabs. All rights reserved.
//

import Foundation
import Firebase

class Tweet{
    var text: String = ""
    var author : String = ""
    var hashtag: String = ""
    var date: String = ""
    var id: String = ""
    let tweetRef: DatabaseReference!
    init(_ text: String, _ author: String, _ hashtag: String, _ date: String, _ id: String = ""){
        self.text = text
        self.author = author
        self.hashtag = hashtag
        self.date = date
        
        tweetRef = Database.database().reference().child("tweets").childByAutoId()
        self.id = tweetRef.key
    }
    
    init (snapshot: DataSnapshot){
        tweetRef = snapshot.ref
        if let value = snapshot.value as? [String : Any]{
            text = value["tweetText"] as! String
            author = value["author"] as! String
            hashtag = value["hashtag"] as! String
            date = value["date"] as! String
            id = value["id"] as! String
        }
    }
    
    func save(){
        tweetRef.setValue(toDictionary())
    }
    
    
    func toDictionary() -> [String : Any]{
        return[
            "tweetText" : text,
            "author" : author,
            "hashtag" : hashtag,
            "date" : date,
            "id" : id
        ]
    }
}
