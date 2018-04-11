//
//  TweetTableViewCell.swift
//  BestProject
//
//  Created by Alina on 4/11/18.
//  Copyright © 2018 a2b DesignLabs. All rights reserved.
//

import UIKit
import Firebase

class TweetTableViewCell: UITableViewCell {
   
    @IBOutlet weak var tweetText: UILabel!
    
    @IBOutlet weak var dislikesLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var liked: UIButton!
    @IBOutlet weak var disliked: UIButton!
    
    var tweet: Tweet! {
        didSet{
            tweetText.text = tweet.text
            likesLabel.text = String(tweet.likes)
            dislikesLabel.text = tweet.author
            print("Success")
        }
    }
    
    @IBAction func likedPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func dislikePressed(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
