//
//  EditRestaurantViewController.swift
//  RestaurantGuide
//
//  Created by Tech on 2022-04-09.
//

import UIKit
import CoreData

class EditRestaurantViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var descrip: UITextField!
    @IBOutlet weak var tags: UITextField!
    @IBOutlet weak var rating: UITextField!
    
    var selectedRestaurant: Restaurant? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedRestaurant != nil){
            name.text = selectedRestaurant?.name
            address.text = selectedRestaurant?.address
            rating.text = selectedRestaurant?.rating.stringValue
            descrip.text = selectedRestaurant?.descrip
            tags.text = selectedRestaurant?.tags
            phone.text = selectedRestaurant?.phone
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveEdit(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        do{
            selectedRestaurant?.name = name.text
            selectedRestaurant?.address = address.text
            selectedRestaurant?.phone = phone.text
            selectedRestaurant?.descrip = descrip.text
            selectedRestaurant?.tags = tags.text
            selectedRestaurant?.rating = Int(rating.text!) as NSNumber?
            try context.save()
            print("Restaurant successfully edited")
            let detailsView = DetailsViewController()
            detailsView.selectedRestaurant = selectedRestaurant
            navigationController?.popViewController(animated: true)
        }
        catch{
            print("Error occured")
        }
    }
    
    
}
