//
//  Photo+CoreDataProperties.swift
//  Filter
//
//  Created by Yisheng Li on 2020/7/12.
//  Copyright © 2020 GreatApps. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var filter: String
    @NSManaged public var currentImage: Data
    @NSManaged public var originalImage: Data
    @NSManaged public var date: Date
    @NSManaged public var volume: Double

}
