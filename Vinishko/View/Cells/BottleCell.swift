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
        wineRegion.text = "Регион: \(model.wineRegion!)"
        bottlePrice.text = "Цена: \(model.price!)₽"
        bottleDescription.text = "Комментарий: \(model.bottleDescription!)"
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
            wineTypeIndicator.text = " Тихое "
        case 1:
            wineTypeIndicator.text = " Игристое "
        case 2:
            wineTypeIndicator.text = " Другое "
        case .none:
            break
        case .some(_):
            break
        }
        
        switch model.wineSugar {
        case 0:
            wineSugarIndicator.text = " Сух "
        case 1:
            wineSugarIndicator.text = " П.сух "
        case 2:
            wineSugarIndicator.text = " П.слад "
        case 3:
            wineSugarIndicator.text = " Слад "
        case .none:
            break
        case .some(_):
            break
        }
    }
}
