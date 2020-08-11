//
//  CategoryViewController.swift
//  Filter
//
//  Created by Yisheng Li on 2020/8/10.
//  Copyright © 2020 GreatApps. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var gallery = [String:[Photo]]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        do{
            let gallery = try  DataController.context.fetch(fetchRequest)
            self.gallery = categorizeGallery(photos:gallery)
            
           // print(categorizeGallery(photos:gallery))
        } catch {
            fatalError("Photos fetch failed")
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 200)
        collectionView.collectionViewLayout = layout
    
        collectionView.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.indentifier)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.indentifier, for: indexPath) as! CategoryCollectionViewCell
        cell.configure(with: UIImage(data: gallery[Array(gallery.keys)[indexPath.row]]![0].currentImage)!, photoLabel: gallery[Array(gallery.keys)[indexPath.row]]![0].category )
        return cell
    }
    
    
    
    func categorizeGallery(photos: [Photo]) -> [String:[Photo]] {
        var gallery = [String:[Photo]]()
        for photo in photos{
            let key = photo.category
            if gallery[key] != nil {
                gallery[key]!.append(photo)
            } else {
                gallery[key] = [photo]
            }
        }
        return gallery
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PresentCategorizedGallery", sender: self)
    }
    
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destination = segue.destination as! GalleryViewController
            let indexPath = self.collectionView.indexPathsForSelectedItems![0]
            destination.gallery = gallery[Array(gallery.keys)[indexPath.row]]!
        }
    
}
