//
//  MyCollectionViewCell.swift
//  Filter
//
//  Created by Yisheng Li on 2020/6/14.
//  Copyright © 2020 GreatApps. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myimage: UIImageView!
    
    static let indentifier = "MyCollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(with filter: Filter){
        self.myLabel.text = filter.label
        self.myimage.image = filter.image
    }
}
