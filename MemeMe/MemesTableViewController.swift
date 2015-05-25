//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Joshua Smith on 5/22/15.
//  Copyright (c) 2015 Square One Nation, LLC. All rights reserved.
//

import UIKit

class MemesTableViewController: UITableViewController
{
    
    var memes : [Meme]!
    var selectedMeme : Meme!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        memes = appDelegate.memes
        tableView.reloadData()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let rect = self.navigationController?.navigationBar.frame
        {
            var y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let meme = memes[indexPath.row]
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        cell.imageView?.image = meme.image

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedMeme = memes[indexPath.row]
        selectedMeme.index = indexPath.row
        performSegueWithIdentifier("showDetail", sender: nil)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var destination = segue.destinationViewController as! MemeDetailViewController
        destination.incomingMeme = selectedMeme
    }

}
