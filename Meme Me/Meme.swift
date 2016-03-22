//
//  Meme.swift
//  Meme Me
//
//  Created by Unathi Chonco on 2016/03/22.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import Foundation
import UIKit

struct  Meme{
    var topText: String? = nil
    var bottomText: String? = nil
    var originalImage: UIImage? = nil
    let memedImage: UIImage
    
    init(topText: String?, bottomText: String?, originalImage: UIImage?, memedImage: UIImage){
        if let topText = topText{
            self.topText = topText
        }
        if let bottomText = bottomText{
            self.bottomText = bottomText
        }
        if let original = originalImage{
            self.originalImage = original
        }
        self.memedImage = memedImage
        
    }
}