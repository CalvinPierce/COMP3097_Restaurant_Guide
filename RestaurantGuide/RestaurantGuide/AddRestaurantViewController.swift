//
//  ViewController.swift
//  RestaurantGuide
//
//  Created by Tech on 2022-03-13.
//

import UIKit
import CoreData

class AddRestaurantViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var descrip: UITextField!
    @IBOutlet weak var tags: UITextField!
    @IBOutlet weak var rating: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func saveRestaurant(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: context)
        let newRestaurant = Restaurant(entity: entity!, insertInto: context)
        newRestaurant.id = restaurantList.count as NSNumber
        newRestaurant.name = name.text
        newRestaurant.address = address.text
        newRestaurant.phone = phone.text
        newRestaurant.descrip = descrip.text
        newRestaurant.tags = tags.text
        newRestaurant.rating = Int(rating.text!) as NSNumber?
        
        do{
            try context.save()
            restaurantList.append(newRestaurant)
            print("Restaurant saved")
        }
        catch{
            print("Error saving restaurant")
        }
    }
    
}
