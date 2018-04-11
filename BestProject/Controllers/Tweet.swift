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
    var likes = 0
    var dislikes = 0
    var hashtag: String = ""
    let tweetRef: DatabaseReference!
    init(_ text: String, _ author: String, _ hashtag: String){
        self.text = text
        self.author = author
        self.hashtag = hashtag
        tweetRef = Database.database().reference().child("tweets").childByAutoId()
    }
    
    init (snapshot: DataSnapshot){
        tweetRef = snapshot.ref
        if let value = snapshot.value as? [String : Any]{
            text = value["tweetText"] as! String
            author = value["author"] as! String
            hashtag = value["hashtag"] as! String
            likes = value["likes"] as! Int
            dislikes = value["dislikes"] as! Int
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
            "likes" : likes,
            "dislikes" : dislikes
        ]
    }
}
