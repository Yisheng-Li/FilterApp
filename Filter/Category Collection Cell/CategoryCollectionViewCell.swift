//
//  CategoryCollectionViewCell.swift
//  Filter
//
//  Created by Yisheng Li on 2020/8/11.
//  Copyright © 2020 GreatApps. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var label: UILabel!
    
    
    static let indentifier = "CategoryCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(with image: UIImage, photoLabel: String){
        imageView.image = image
        label.text = photoLabel
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
    }

}
