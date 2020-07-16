//
//  GalleryViewController.swift
//  Filter
//
//  Created by Yisheng Li on 2020/7/12.
//  Copyright © 2020 GreatApps. All rights reserved.
//

import UIKit
import CoreData


class GalleryViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    var gallery = [Photo]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        do{
            let gallery = try  DataController.context.fetch(fetchRequest)
            self.gallery = gallery
        } catch {
            fatalError("Photos fetch failed")
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 200)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(GalleryCollectionViewCell.nib(), forCellWithReuseIdentifier: GalleryCollectionViewCell.indentifier)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.indentifier, for: indexPath) as! GalleryCollectionViewCell
        
        cell.configure(with: UIImage(data: gallery[indexPath.row].currentImage)!)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "PresentPhotoDetails", sender: self)
        
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        self.performSegue(withIdentifier: "PresentPhotoDetails", sender: self)
    //    }
    
}
