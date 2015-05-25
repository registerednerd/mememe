//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Josh Smith on 5/25/15.
//  Copyright (c) 2015 Square One Nation, LLC. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController
{

    @IBOutlet weak var imageView: UIImageView!
    var incomingMeme: Meme!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imageView.image = incomingMeme.generateMemedImage()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
