//
//  PhotoViewController.swift
//  Filter
//
//  Created by Yisheng Li on 2020/7/16.
//  Copyright © 2020 GreatApps. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var photo: Photo! = nil
   // var label: String = ""
    
    
  //  @IBOutlet var label: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var filterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imageView.image =  UIImage(data: photo.currentImage)
        dateLabel.text = String(photo.date.description.split(separator: " ")[0])
        filterLabel.text = photo.filter
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
