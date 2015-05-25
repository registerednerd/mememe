//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Joshua Smith on 5/22/15.
//  Copyright (c) 2015 Square One Nation, LLC. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class MemesCollectionViewController: UICollectionViewController
{
    var memes : [Meme]!
    let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var selectedMeme : Meme!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let rect = self.navigationController?.navigationBar.frame
        {
            var y = rect.size.height + rect.origin.y
            self.collectionView?.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let destination = segue.destinationViewController as! MemeDetailViewController
        destination.incomingMeme = selectedMeme
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let meme = memes[indexPath.row]

        let cell : MemeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        
        //populate cell
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        cell.imageView.image = meme.image
    
        //Configure the cell
    
        return cell
    }

    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        selectedMeme = memes[indexPath.row]
        selectedMeme.index = indexPath.row
        performSegueWithIdentifier("showDetail", sender: nil)
        return true
    }

}
