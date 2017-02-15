//
//  PostCell.swift
//  SocialMedia
//
//  Created by 홍창남 on 2017. 2. 13..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit
import Firebase

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

    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        
        if let image = img {
            self.postImg.image = image
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error) in
                if error != nil {
                    print("창남 - Firebase storage에서 이미지를 다운로드할 수 없습니다.")
                } else {
                    print("창남 - 이미지가 Firebase storage에서 다운로드 되었습니다.")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as AnyObject)
                        }
                    }
                }
            })
        }
    }
}
