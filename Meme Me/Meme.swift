//
//  Meme.swift
//  Meme Me
//
//  Created by Layne Faler on 6/7/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import Foundation
import UIKit

struct FontAttributes {
    var fontSize: CGFloat = 40.0
    var fontName = "HelveticaNeue-CondensedBlack"
    var fontColor = UIColor.whiteColor()
    var borderColor = UIColor.blackColor()
    var strokeSize: CGFloat = -3.0
}

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    var fontAttributes: FontAttributes
}