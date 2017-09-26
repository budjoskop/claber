//
//  MasterCell.swift
//  claber2
//
//  Created by Ognjen Tomić on 6/8/17.
//  Copyright © 2017 Ognjen Tomić. All rights reserved.
//

import UIKit

class MasterCell: UITableViewCell {
    
    
    
    //Outleti za Celiju
    
    @IBOutlet weak var eventOutlet: UILabel!
    @IBOutlet weak var placeOutlet: UILabel!
    @IBOutlet weak var descOutlet: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var cellEfectOutlet: UIVisualEffectView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
