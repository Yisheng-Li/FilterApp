//
//  GalleryViewController.swift
//  Filter
//
//  Created by Yisheng Li on 2020/7/12.
//  Copyright © 2020 GreatApps. All rights reserved.
//

import UIKit
import CoreData


class GalleryViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    var gallery = [Photo]()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
        do{
            let gallery = try  DataController.context.fetch(fetchRequest)
            self.gallery = gallery
        } catch { }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gallery.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let calendar = Calendar.current
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "\(String(describing: gallery[indexPath.row].filter)) + \(gallery[indexPath.row].volume)"
        cell.detailTextLabel?.text = String(calendar.component(.minute, from: gallery[indexPath.row].date!))
        return cell
    }
    
}
