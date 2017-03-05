//
//  PostCell.swift
//  SocialMedia
//
//  Created by 홍창남 on 2017. 2. 13..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post) {
        
        self.post = post
        
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
    }
}
