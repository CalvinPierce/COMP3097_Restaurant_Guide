//
//  Restaurant.swift
//  RestaurantGuide
//
//  Created by Tech on 2022-04-09.
//

import CoreData

@objc(Restaurant)
class Restaurant: NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var address: String!
    @NSManaged var phone: String!
    @NSManaged var descrip: String!
    @NSManaged var tags: String!
    @NSManaged var rating: NSNumber!
}
