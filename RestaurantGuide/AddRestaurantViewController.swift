//
//  ViewController.swift
//  RestaurantGuide
//
//  Created by Tech on 2022-03-13.
//

import UIKit
import CoreData
import GooglePlaces
import SwiftyJSON

class AddRestaurantViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var descrip: UITextField!
    @IBOutlet weak var tags: UITextField!
    @IBOutlet weak var rating: UITextField!
    
    @IBOutlet weak var status: UILabel!
    var addressText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        phone.delegate = self
        
        
    }
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
        
    @IBAction func autocompleteType(_ sender: Any) {
        //print("You touched the address")
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
    
    @IBAction func ratingNum(_ sender: UITextField) {
        if let last = sender.text?.last {
                let zero: Character = "0"
                let num: Int = Int(UnicodeScalar(String(last))!.value - UnicodeScalar(String(zero))!.value)
            if (num < 1 || num > 5 || sender.text!.count > 1) {
                    //remove the last character as it is invalid
                    sender.text?.removeLast()
                }
            }
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
            name.text = ""
            address.text = ""
            phone.text = ""
            descrip.text = ""
            tags.text = ""
            rating.text = ""
            status.text = "Restaurant saved"
            print("Restaurant saved")
        }
        catch{
            print("Error saving restaurant")
        }
    }
}
extension AddRestaurantViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      
      // Create URL
      let url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?fields=formatted_address&place_id=\(place.placeID!)&key=AIzaSyAeVSrX3nnWF_2aIMXfinq-oCy9IbfMB68")
      guard let requestUrl = url else { fatalError() }

      // Create URL Request
      var request = URLRequest(url: requestUrl)

      // Specify HTTP Method to use
      request.httpMethod = "GET"

      // Send HTTP Request
      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
          
          // Check if Error took place
          if let error = error {
              print("Error took place \(error)")
              return
          }
          
          // Read HTTP Response Status code
          if let response = response as? HTTPURLResponse {
              print("Response HTTP Status code: \(response.statusCode)")
          }
          
          // Convert HTTP Response Data to a simple String
          if let data = data, let dataString = String(data: data, encoding: .utf8) {
              //print("Response data string:\n \(dataString)")
              let json = JSON(data)
              self.addressText = json["result"]["formatted_address"].string!
              //print(self.addressText)
              changeTextField()
          }
      }
      task.resume()
      func changeTextField(){
          DispatchQueue.main.async {
              self.address.text = self.addressText
          }
      }
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
