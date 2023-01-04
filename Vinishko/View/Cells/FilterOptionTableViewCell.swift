//
//  FilterOptionTableViewCell.swift
//  Vinishko
//
//  Created by Денис on 02.01.2023.
//

import UIKit

class FilterOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    
    func setup(model: FilterOption) {
        optionLabel.text = model.title
    }
    
}
