//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by Layne Faler on 6/6/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    @IBOutlet var frameTableLayout: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if CollectionOfMemes.count() == 0 {
            let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("EditorViewController")
            let memeCreatorVC = object as! EditorViewController
            presentViewController(memeCreatorVC, animated: false, completion: nil)
        }
        navigationItem.leftBarButtonItem?.enabled = CollectionOfMemes.count() > 0
        tableView!.reloadData()
    }
    
    
    /* Present the meme creator with cancel button enabled */
    @IBAction func didPressAdd(sender: AnyObject) {
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("EditorViewController")
        let newMemeVC = object as! EditorViewController
        presentViewController(newMemeVC, animated: true, completion: {
            newMemeVC.cancelButton.enabled = true
        })
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if !tableView.editing {
            tableView.setEditing(editing, animated: animated)
        }
    }
}

extension MemeTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollectionOfMemes.count()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath)
        
        let meme = CollectionOfMemes.allMemes[indexPath.row]
        cell.textLabel!.text = "\(meme.topText)...\(meme.bottomText)"
        cell.imageView!.image = meme.originalImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            
            CollectionOfMemes.remove(atIndex: indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            if CollectionOfMemes.count() == 0 {
                let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("EditorViewController")
                let memeCreatorVC = object as! EditorViewController
                presentViewController(memeCreatorVC, animated: false, completion: nil)
            }
            
        default:
            
            return
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !tableView.editing {
            let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")
            let detailVC = object as! DetailViewController
            
            detailVC.meme = CollectionOfMemes.allMemes[indexPath.row]
            navigationController!.pushViewController(detailVC, animated: true)
        }
    }
}

