//
//  EditRestaurantViewController.swift
//  RestaurantGuide
//
//  Created by Tech on 2022-04-09.
//

import UIKit
import CoreData
import GooglePlaces

class EditRestaurantViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var descrip: UITextField!
    @IBOutlet weak var tags: UITextField!
    @IBOutlet weak var rating: UITextField!
    
    var selectedRestaurant: Restaurant? = nil
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func autocompleteType(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
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
        phone.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let currentText:String = textField.text else {return true}
            if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil { return false }
            let newCount:Int = currentText.count + string.count - range.length
            let addingCharacter:Bool = range.length <= 0

            if(newCount == 1){
                textField.text = addingCharacter ? currentText + "(\(string)" : String(currentText.dropLast(2))
                return false
            }else if(newCount == 5){
                textField.text = addingCharacter ? currentText + ") \(string)" : String(currentText.dropLast(2))
                return false
            }else if(newCount == 10){
                textField.text = addingCharacter ? currentText + "-\(string)" : String(currentText.dropLast(2))
                return false
            }

            if(newCount > 14){
                return false
            }

            return true
        }
    
    @IBAction func saveEdit(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        //let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
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

extension EditRestaurantViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    address.text = "\(place.name!)"
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}

