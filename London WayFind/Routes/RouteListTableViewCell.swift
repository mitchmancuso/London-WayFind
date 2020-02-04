//
//  RouteListTableViewCell.swift
//  London WayFind
//
//  Created by Cara Rosevear on 2019-03-26.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit

class RouteListTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet var favButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameRoute: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
