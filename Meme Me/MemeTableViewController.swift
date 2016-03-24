//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by Unathi Chonco on 2016/03/22.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! MemeTableViewCell
        
        var text = ""
        if let top = memes[indexPath.row].topText{
            text += top
        }
        if let bottom = memes[indexPath.row].bottomText{
            text += " \(bottom)"
        }
        
        cell.memeLabel?.text = text
        cell.memeImage?.image = memes[indexPath.row].memedImage

        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memedImage = memes[indexPath.row].memedImage
        let vc = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        vc.meme = memedImage
        navigationController?.pushViewController(vc, animated: true)
        
    }

    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row-1)
            memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }  
    }



}
