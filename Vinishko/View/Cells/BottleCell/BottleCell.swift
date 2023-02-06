//
//  BottleCell.swift
//  Vinishko
//
//  Created by Денис on 02.10.2022.
//

import UIKit

class BottleCell: UITableViewCell {
    
    @IBOutlet weak var bottleImage: UIImageView!
    @IBOutlet weak var bottleName: UILabel!
    @IBOutlet weak var bottleDescription: UILabel!
    @IBOutlet weak var wineRegion: UILabel!
    @IBOutlet weak var bottlePrice: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var wineColorIndicator: UIView!
    @IBOutlet weak var wineTypeIndicator: UILabel!
    @IBOutlet weak var wineSugarIndicator: UILabel!
    @IBOutlet weak var countryIndicator: UILabel!
    
    func setup(model: Bottle) {
        
        bottleImage.image = UIImage(data: model.bottleImage!)
        bottleName.text = model.name
        wineRegion.text = String(model.wineRegion!)
        bottlePrice.text = String(model.price!)
        bottleDescription.text = String(model.bottleDescription!)
        countryIndicator.text = " \(model.wineCountry!) "
        dateLabel.text = model.date
        ratingControl.rating = model.rating
                
        switch model.wineColor {
        case 0:
            wineColorIndicator.backgroundColor = .redWineColor
        case 1:
            wineColorIndicator.backgroundColor = .whiteWineColor
        case 2:
            wineColorIndicator.backgroundColor = .otherWineColor
        case .none:
            break
        case .some(_):
            break
        }
        
        switch model.wineType {
        case 0:
            wineTypeIndicator.text = LocalizableText.still
        case 1:
            wineTypeIndicator.text = LocalizableText.sparkling
        case 2:
            wineTypeIndicator.text = LocalizableText.other
        case .none:
            break
        case .some(_):
            break
        }
        
        switch model.wineSugar {
        case 0:
            wineSugarIndicator.text = LocalizableText.dry
        case 1:
            wineSugarIndicator.text = LocalizableText.sDry
        case 2:
            wineSugarIndicator.text = LocalizableText.sSweet
        case 3:
            wineSugarIndicator.text = LocalizableText.sweet
        case .none:
            break
        case .some(_):
            break
        }
    }
}
