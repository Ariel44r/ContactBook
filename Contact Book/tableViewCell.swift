//
//  tableViewCell.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 29/09/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import UIKit

class tableViewCell: UITableViewCell {

    ///MARK: outletsAndActions
    
    @IBOutlet weak var UIImageContact: UIImageView!
    @IBOutlet weak var labelContact: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
