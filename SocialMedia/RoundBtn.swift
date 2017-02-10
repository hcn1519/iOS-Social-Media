//
//  RoundBtn.swift
//  SocialMedia
//
//  Created by 홍창남 on 2017. 2. 10..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class RoundBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: SHADOW_GRAY).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView?.contentMode = .scaleAspectFit
        layer.cornerRadius = 5.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width/2
    }

}
