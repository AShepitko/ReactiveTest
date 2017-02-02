//
//  RepoTableViewCell.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 01/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
