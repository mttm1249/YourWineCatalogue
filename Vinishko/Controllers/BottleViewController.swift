//
//  BottleViewController.swift
//  Vinishko
//
//  Created by Денис on 20.11.2022.
//

import UIKit
import RealmSwift
import CoreImage
import FirebaseStorage

protocol UpdateBottlesList: AnyObject {
    func updateTableView()
}

class BottleViewController: UIViewController, UpdateTableView {
    
    var context = CIContext(options: nil)
    var currentBottle: Bottle!
    weak var delegate: UpdateBottlesList?
    private var qrImage = UIImage()
    private var imageURL = "" {
        didSet {
            feedbackGenerator.impactOccurred(intensity: 1.0)
            generateQR(with: imageURL)
            progressView.isHidden = true
            performSegue(withIdentifier: "showQR", sender: nil)
        }
    }
    
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
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true
        progressView.progress = 0
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
    
    @IBAction func generateAction(_ sender: Any) {
        progressView.isHidden = false
        
        // Upload image to Firebase
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "images/\(randomID).jpg")
        guard let imageData = bottleImage.image?.jpegData(compressionQuality: 0.3) else { return }
        
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpg"
        
        let taskReference = uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print("Oh no! Got an error! \(error.localizedDescription)")
                return
            }
            uploadRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("Got an error generating URL: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    self.imageURL = url.absoluteString
                }
            })
        }
        // ProgressView
        taskReference.observe(.progress) { [weak self] (snapshot) in
            guard let progressValue = snapshot.progress?.fractionCompleted else { return }
            self?.progressView.progress = Float(progressValue)
        }
    }
    
    private func checkPermissionForSharing(by key: String, value: String) -> String {
        let result = userDefaults.bool(forKey: key)
        if result == true {
            return value
        }
        return ""
    }
    
    private func checkPermissionForSharingRating(by key: String, value: Int) -> Int {
        let result = userDefaults.bool(forKey: key)
        if result == true {
            return value
        }
        return 0
    }
    
    private func generateQR(with imageURL: String) {
        // Converting JSON string to UIImage
        qrImage = QRGenerator.generateQR(imageURL: checkPermissionForSharing(by: "shareImage", value: imageURL),
                                         name: currentBottle.name!,
                                         wineColor: currentBottle.wineColor!,
                                         wineSugar: currentBottle.wineSugar!,
                                         wineType: currentBottle.wineType!,
                                         wineSort: currentBottle.wineSort!,
                                         wineCountry: currentBottle.wineCountry!,
                                         wineRegion: currentBottle.wineRegion!,
                                         placeOfPurchase: currentBottle.placeOfPurchase!,
                                         price: currentBottle.price!,
                                         bottleDescription: checkPermissionForSharing(by: "shareComment", value: currentBottle.bottleDescription!),
                                         rating: checkPermissionForSharingRating(by: "shareRating", value: currentBottle.rating)) ?? UIImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQR" {
            let vc = segue.destination as! QRViewController
            vc.generatedQRImage = qrImage
        }
    }
}
