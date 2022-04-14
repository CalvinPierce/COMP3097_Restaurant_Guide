//
//  DetailsViewController.swift
//  RestaurantGuide
//
//  Created by Tech on 2022-03-13.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
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
    @IBAction func refresh(_ sender: Any) {
        name.text = selectedRestaurant?.name
        address.text = selectedRestaurant?.address
        rating.text = selectedRestaurant?.rating.stringValue
        descrip.text = selectedRestaurant?.descrip
        tags.text = selectedRestaurant?.tags
        phone.text = selectedRestaurant?.phone
    }
    
    func refreshData(){
        name.text = selectedRestaurant?.name
        address.text = selectedRestaurant?.address
        rating.text = selectedRestaurant?.rating.stringValue
        descrip.text = selectedRestaurant?.descrip
        tags.text = selectedRestaurant?.tags
        phone.text = selectedRestaurant?.phone
    }
    @IBAction func shareAction(_ sender : UIButton){
        let imageToShare = [self.view.asImage()]
        let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editRestaurant"){
            let editRestaurant = segue.destination as? EditRestaurantViewController
            editRestaurant?.selectedRestaurant = selectedRestaurant
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
