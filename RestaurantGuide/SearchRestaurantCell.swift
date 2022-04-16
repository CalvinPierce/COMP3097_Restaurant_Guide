//
//  SearchRestaurantCell.swift
//  RestaurantGuide
//
//  Created by Nilay on 10/04/22.
//

import UIKit

protocol SearchCellDelegate {
    func shareTapped(index : Int)
}

class SearchRestaurantCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var shareButton : UIButton!
    
    var delegate : SearchCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func shareAction(_ sender : UIButton){
        delegate.shareTapped(index: sender.tag)
    }

}
