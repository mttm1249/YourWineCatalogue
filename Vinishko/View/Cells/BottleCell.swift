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
        let currentLanguage = Locale.current.identifier
        
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
            if currentLanguage != "ru_RU" {
                wineTypeIndicator.text = " Still "
            } else {
                wineTypeIndicator.text = " Тихое "
            }
        case 1:
            if currentLanguage != "ru_RU" {
                wineTypeIndicator.text = " Sparkling "
            } else {
                wineTypeIndicator.text = " Игристое "
            }
        case 2:
            if currentLanguage != "ru_RU" {
                wineTypeIndicator.text = " Other "
            } else {
                wineTypeIndicator.text = " Другое "
            }
        case .none:
            break
        case .some(_):
            break
        }
        
        switch model.wineSugar {
        case 0:
            if currentLanguage != "ru_RU" {
                wineSugarIndicator.text = " Dry "
            } else {
                wineSugarIndicator.text = " Сух "
            }
        case 1:
            if currentLanguage != "ru_RU" {
                wineSugarIndicator.text = " S.dry "
            } else {
                wineSugarIndicator.text = " П.сух "
            }
        case 2:
            if currentLanguage != "ru_RU" {
                wineSugarIndicator.text = " S.sweet "
            } else {
                wineSugarIndicator.text = " П.слад "
            }
        case 3:
            if currentLanguage != "ru_RU" {
                wineSugarIndicator.text = " Sweet "
            } else {
                wineSugarIndicator.text = " Слад "
            }
        case .none:
            break
        case .some(_):
            break
        }
    }
}
