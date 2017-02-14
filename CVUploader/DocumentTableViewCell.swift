//
//  DocumentTableViewCell.swift
//  CVUploader
//
//  Created by Trum Gyorgy on 2017. 02. 14..
//  Copyright © 2017. Trum Gyorgy. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var sizeLabel: UILabel!

    @IBOutlet weak var createLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
