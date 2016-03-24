//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Unathi Chonco on 2016/03/23.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    var meme: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let sentMeme = meme else{
            return
        }
        memeImage.image = sentMeme

        memeImage.contentMode = .ScaleAspectFit
    }

}
