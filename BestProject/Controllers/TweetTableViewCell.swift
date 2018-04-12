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
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            tweetText.text = tweet.text + "\n" + tweet.hashtag
            authorLabel.text = "by " + tweet.author
            dateLabel.text = tweet.date
            print("Success")
        }
    }
    
    @IBAction func likedPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func dislikePressed(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        tweetText.numberOfLines = 10
        authorLabel.minimumScaleFactor = 10/UIFont.labelFontSize
        authorLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 10/UIFont.labelFontSize
        dateLabel.adjustsFontSizeToFitWidth = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
