//
//  DetailViewController.swift
//  Meme Me
//
//  Created by Layne Faler on 6/6/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let meme = meme {
            detailImageView.image = meme.memedImage
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMemeEditor" {
            let editVC = segue.destinationViewController as! EditorViewController
            editVC.editMeme = meme
            editVC.userIsEditing = true
        }
        
        if segue.identifier == "showDetailCollection" {
            segue.destinationViewController as! MemeCollectionViewController
        }
        
        if segue.identifier == "showDetailTables" {
            segue.destinationViewController as! MemeTableViewController
        }
    }

}
