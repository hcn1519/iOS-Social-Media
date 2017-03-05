//
//  CircleView.swift
//  SocialMedia
//
//  Created by 홍창남 on 2017. 2. 13..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
    }
}
