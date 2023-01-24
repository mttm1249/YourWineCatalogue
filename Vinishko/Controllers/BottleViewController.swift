//
//  BottleViewController.swift
//  Vinishko
//
//  Created by Денис on 20.11.2022.
//

import UIKit
import RealmSwift
import CoreImage

protocol UpdateBottlesList: AnyObject {
    func updateTableView()
}

class BottleViewController: UIViewController, UpdateTableView {

    var context = CIContext(options: nil)
    var currentBottle: Bottle!
    weak var delegate: UpdateBottlesList?

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bottleImage: UIImageView!
    @IBOutlet weak var bottleName: UILabel!
    @IBOutlet weak var wineSort: UILabel!
    @IBOutlet weak var wineCountry: UILabel!
    @IBOutlet weak var wineRegion: UILabel!
    @IBOutlet weak var placeOfPurchase: UILabel!
    @IBOutlet weak var bottlePrice: UILabel!
    @IBOutlet weak var bottleDescription: UITextView!
    @IBOutlet weak var ratingCircleView: UIView!
    @IBOutlet weak var bottleRatingLabel: UILabel!
    
    @IBOutlet weak var wineColorIndicator: UIView!
    @IBOutlet weak var wineTypeIndicator: UILabel!
    @IBOutlet weak var wineSugarIndicator: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageBlurEffect()
        setupInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateTableView()
    }
    
    func setupInfo() {
        bottleName.text = currentBottle.name
        wineSort.text = currentBottle.wineSort
        wineCountry.text = currentBottle.wineCountry
        wineRegion.text = currentBottle.wineRegion
        placeOfPurchase.text = currentBottle.placeOfPurchase
        bottlePrice.text = currentBottle.price
        bottleDescription.text = currentBottle.bottleDescription
        setupRatingCircle()
        setupIndicators()
    }
    
    func setupRatingCircle() {
        // setup circle style
        ratingCircleView.layer.borderWidth = 2
        ratingCircleView.layer.borderColor  = .init(red: 255, green: 255, blue: 255, alpha: 1)
        
        guard currentBottle != nil else { return }
        
        bottleRatingLabel.text = "\(currentBottle.rating)"
        if currentBottle.rating >= 4 {
            ratingCircleView.backgroundColor = #colorLiteral(red: 0, green: 0.770498693, blue: 0, alpha: 1)
        } else if currentBottle.rating == 3 {
            ratingCircleView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else {
            ratingCircleView.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
    
    func setupIndicators() {
        switch currentBottle.wineColor {
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
        
        switch currentBottle.wineType {
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
        
        switch currentBottle.wineSugar {
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
    
    func backgroundImageBlurEffect() {
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        guard let data = currentBottle?.bottleImage, let image = UIImage(data: data) else { return }
        bottleImage.image = image
        let beginImage = CIImage(image: image)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(30, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        bgImageView.image = processedImage
    }
    
    @IBAction func editButton(_ sender: Any) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "editBottle") as? NewBottleViewController else { return }
        editVC.currentBottle = currentBottle
        editVC.isEdited = true
        editVC.delegate = self
        editVC.modalPresentationStyle = .pageSheet
        present(editVC, animated: true)
    }
    
    func updateCurrentBottleInfo() {
        backgroundImageBlurEffect()
        setupInfo()
    }
    
}
