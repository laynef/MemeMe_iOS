//
//  Utilities.swift
//  Meme Me
//
//  Created by Layne Faler on 6/6/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import Foundation
import UIKit

struct CollectionOfMemes {
    
    static func getMemeStorageInDelegate() -> AppDelegate {
        let object = UIApplication.sharedApplication().delegate
        return object as! AppDelegate
    }
    
    static var allMemes: [Meme] {
        return getMemeStorageInDelegate().savedMemes
    }
    
    static func getMeme(atIndex index: Int) -> Meme {
        return allMemes[index]
    }
    
    static func indexOf(meme: Meme) -> Int {
        
        if let index = allMemes.indexOf({$0 == meme}) {
            return Int(index)
        } else {
            return allMemes.count
        }
    }
    
    static func add(meme: Meme) {
        getMemeStorageInDelegate().savedMemes.append(meme)
    }
    
    static func update(atIndex index: Int, withMeme meme: Meme) {
        getMemeStorageInDelegate().savedMemes[index] = meme
    }
    
    static func remove(atIndex index: Int) {
        getMemeStorageInDelegate().savedMemes.removeAtIndex(index)
    }
    
    static func count() -> Int {
        return getMemeStorageInDelegate().savedMemes.count
    }
    
}

func ==(lhs: Meme, rhs: Meme) -> Bool {
    return lhs.memedImage == rhs.memedImage
}
