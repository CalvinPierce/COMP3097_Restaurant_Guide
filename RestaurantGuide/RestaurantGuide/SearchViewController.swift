//
//  SearchViewController.swift
//  RestaurantGuide
//
//  Created by Nilay on 10/04/22.
//

import UIKit
import CoreData
class SearchViewController: UIViewController {
    var restaurantList = [Restaurant]()
    var filteredrestaurantList = [Restaurant]()
    @IBOutlet weak var searchTableView : UITableView!
    @IBOutlet weak var searchTf : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    override func viewWillAppear(_ animated: Bool) {
        restaurantList.removeAll()
        filteredrestaurantList.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results{
                let restaurant = result as! Restaurant
                restaurantList.append(restaurant)
                filteredrestaurantList.append(restaurant)
                
            }
            searchTableView.reloadData()
        }
        catch{
            print("Data could not be retrieved")
        }
    }
    @IBAction func searchAction(_ sender : UIButton){
        self.filteredrestaurantList = restaurantList.filter({$0.name.contains(searchTf.text ?? "") || ($0.tags.contains(searchTf.text ?? ""))})
        if searchTf.text == ""{
            self.filteredrestaurantList = restaurantList
        }
        searchTableView.reloadData()
    }

}
extension SearchViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredrestaurantList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRestaurantCell", for: indexPath) as! SearchRestaurantCell
        let thisRestaurant = filteredrestaurantList[indexPath.row]
            cell.name.text = thisRestaurant.name
            cell.address.text = thisRestaurant.address
            cell.tags.text = "Tags:" + thisRestaurant.tags
            cell.rating.text = "Rating: " + thisRestaurant.rating.stringValue
        cell.shareButton.tag = indexPath.row
        cell.shareButton.isHidden = false
        cell.delegate = self
        return cell
    }
    
}

extension SearchViewController : SearchCellDelegate{
    func shareTapped(index: Int) {
        // image to share
        let cell = searchTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! SearchRestaurantCell
        cell.shareButton.isHidden = true
            // set up activity view controller
        let imageToShare = [cell.contentView.asImage()]
        let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

            // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)

        searchTableView.reloadData()
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view

//        self.present(alert, animated: true, completion: {
//            print("completion block")
//        })
    }
    
  
}


extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
