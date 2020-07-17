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
    
    @IBAction func onShare(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func onContiuneEditing(_ sender: Any) {
      
        
        navigationController?.dismiss(animated: true, completion: nil)
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
