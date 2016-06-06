//
//  CollectionViewCell.swift
//  Meme Me
//
//  Created by Layne Faler on 6/6/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectedImageView: UIImageView!
    
    func isSelected(selected: Bool) {
        if selected {
            selectedImageView.hidden = false
        } else {
            selectedImageView.hidden = true
        }
    }
    
}
