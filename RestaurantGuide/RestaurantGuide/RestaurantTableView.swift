//
//  RestaurantTableView.swift
//  RestaurantGuide
//
//  Created by Tech on 2022-04-09.
//

import UIKit
import CoreData

var restaurantList = [Restaurant]()

class RestaurantTableView: UITableViewController{
    var firstLoad = true
    
    override func viewDidLoad() {
        if(firstLoad){
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results{
                    let restaurant = result as! Restaurant
                    restaurantList.append(restaurant)
                }
            }
            catch{
                print("Data could not be retrieved")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resturantCell = tableView.dequeueReusableCell(withIdentifier: "restaurantCellID", for: indexPath) as! RestaurantCell
        
        let thisRestaurant: Restaurant!
        thisRestaurant = restaurantList[indexPath.row]
        
        resturantCell.name.text = thisRestaurant.name
        resturantCell.address.text = thisRestaurant.address
        resturantCell.tags.text = "Tags:" + thisRestaurant.tags
        resturantCell.rating.text = "Rating: " + thisRestaurant.rating.stringValue
        
        return resturantCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "restaurantDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "restaurantDetails"){
            let indexPath = tableView.indexPathForSelectedRow!
            
            let restaurantDetail = segue.destination as? DetailsViewController
            
            let selectedRestaurant : Restaurant!
            selectedRestaurant = restaurantList[indexPath.row]
            restaurantDetail?.selectedRestaurant = selectedRestaurant
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
