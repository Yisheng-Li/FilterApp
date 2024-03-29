//
//  GalleryCollectionViewCell.swift
//  Filter
//
//  Created by Yisheng Li on 2020/7/15.
//  Copyright © 2020 GreatApps. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    static let indentifier = "GalleryCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(with image: UIImage){
        imageView.image = image
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "GalleryCollectionViewCell", bundle: nil)
    }
    
}
