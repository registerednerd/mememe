//
//  Meme.swift
//  MemeMe
//
//  Created by Joshua Smith on 5/22/15.
//  Copyright (c) 2015 Square One Nation, LLC. All rights reserved.
//

import UIKit

class Meme: NSObject
{
    var image : UIImage
    var topText : String
    var bottomText : String
    var index : Int!
    
    init (image: UIImage, topText: String, bottomText: String)
    {
        self.image = image
        self.topText = topText
        self.bottomText = bottomText
    }
    
    func generateMemedImage() -> UIImage
    {
        let memeTextAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: self.image.size.width/12)!, NSStrokeWidthAttributeName: -3.0]
        let imageRect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.image.size)
        let attributedTop = NSAttributedString(string: self.topText, attributes: memeTextAttributes)
        let attributedBottom = NSAttributedString(string: self.bottomText, attributes: memeTextAttributes)
        let topRect = CGRect(x: imageRect.width/2 - attributedTop.size().width/2, y: attributedTop.size().height/2, width: attributedTop.size().width ,height: attributedTop.size().height)
        let bottomRect = CGRect(x: imageRect.width/2 - attributedBottom.size().width/2, y: imageRect.size.height - attributedTop.size().height*1.5, width: attributedBottom.size().width, height: attributedBottom.size().height)
        
        UIGraphicsBeginImageContext(imageRect.size)
        image.drawInRect(imageRect)
        attributedTop.drawInRect(topRect)
        attributedBottom.drawInRect(bottomRect)

        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
}
