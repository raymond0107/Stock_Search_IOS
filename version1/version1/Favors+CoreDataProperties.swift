//
//  Favors+CoreDataProperties.swift
//  version1
//
//  Created by Luzhen Qian on 5/4/16.
//  Copyright © 2016 Luzhen_Qian. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Favors {

    @NSManaged var symbol: String?
    @NSManaged var name: String?
    @NSManaged var change: String?
    @NSManaged var price: String?
    @NSManaged var mCap: String?
    @NSManaged var background: String?
}
