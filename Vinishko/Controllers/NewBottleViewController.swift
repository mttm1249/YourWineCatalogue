//
//  MainViewController.swift
//  Vinishko
//
//  Created by Денис on 01.10.2022.
//

import UIKit
import Network
import AVFoundation

struct QRModel : Decodable {
    let verification: String
    let name: String
    let wineColor: Int
    let wineSugar: Int
    let wineType: Int
    let wineSort: String
    let wineCountry: String
    let wineRegion: String
    let placeOfPurchase: String
    let bottleDescription: String
    let rating: Int
    let price: String
}

protocol UpdateTableView: AnyObject {
    func updateCurrentBottleInfo()
}

class NewBottleViewController: UIViewController, UpdateFromQR {
    
    weak var delegate: UpdateTableView?
    var currentBottle: Bottle!
    var isEdited: Bool?
    private let time = Time()
    private let monitor = NWPathMonitor()
    
    private var wineColorId = 0
    private var wineTypeId = 0
    private var wineSugarId = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottleImage: UIImageView!
    @IBOutlet weak var bottleNameTF: UITextField!
    @IBOutlet weak var bottleDescriptionTF: UITextField!
    @IBOutlet weak var placeOfPurchaseTF: UITextField!
    @IBOutlet weak var wineSortTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var regionTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var wineColorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var wineTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var wineSugarSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkConnection()
        scrollView.delegate = self
        hideKeyboard()
        setupEditScreen()
    }
    
    // QR Delegate method
    func updateBottleInfo(string: String) {
        if let result = try? JSONDecoder().decode(QRModel.self, from: Data(string.utf8)) {
            guard result.verification == "VinishkoAPP" else { return }
            bottleNameTF.text = result.name
            wineColorSegmentedControl.selectedSegmentIndex = result.wineColor
            wineSugarSegmentedControl.selectedSegmentIndex = result.wineSugar
            wineTypeSegmentedControl.selectedSegmentIndex = result.wineType
            wineColorId = result.wineColor
            wineSugarId = result.wineSugar
            wineTypeId = result.wineType
            wineSortTF.text = result.wineSort
            countryTF.text = result.wineCountry
            regionTF.text = result.wineRegion
            placeOfPurchaseTF.text = result.placeOfPurchase
            priceTF.text = result.price
            bottleDescriptionTF.text = result.bottleDescription
            ratingControl.rating = result.rating
            setupWineColorSegments(section: result.wineColor)
        }
    }
    
    private func checkConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.addButton.isEnabled = true
                    self.addButton.tintColor = .white
                    self.addButton.loadingIndicator(false)
                }
            } else {
                DispatchQueue.main.async {
                    self.addButton.isEnabled = false
                    self.addButton.tintColor = .clear
                    self.addButton.loadingIndicator(true)
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    private func setupEditScreen() {
        // ScrollView moving up with keyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // UIImagePickerController calls when UIImageView tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        bottleImage.isUserInteractionEnabled = true
        bottleImage.addGestureRecognizer(tapGestureRecognizer)
        
        // White color for wine color selector
        wineColorSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        if currentBottle != nil {
            guard let data = currentBottle?.bottleImage, let image = UIImage(data: data) else { return }
            bottleImage.image = image
            bottleImage.contentMode = .scaleAspectFill
            bottleNameTF.text = currentBottle.name
            bottleDescriptionTF.text = currentBottle.bottleDescription
            placeOfPurchaseTF.text = currentBottle.placeOfPurchase
            countryTF.text = currentBottle.wineCountry
            regionTF.text = currentBottle.wineRegion
            priceTF.text = currentBottle.price
            ratingControl.rating = currentBottle!.rating
            wineSortTF.text = currentBottle.wineSort
            
            wineColorSegmentedControl.selectedSegmentIndex = currentBottle.wineColor!
            setupWineColorSegments(section: currentBottle.wineColor!)
            
            wineTypeSegmentedControl.selectedSegmentIndex = currentBottle.wineType!
            wineSugarSegmentedControl.selectedSegmentIndex = currentBottle.wineSugar!
            wineColorId = currentBottle.wineColor!
            wineTypeId = currentBottle.wineType!
            wineSugarId = currentBottle.wineSugar!
        }
    }
    
    func setupWineColorSegments(section: Int) {
        switch section {
        case 0:
            wineColorSegmentedControl.selectedSegmentTintColor = .redWineColor
        case 1:
            wineColorSegmentedControl.selectedSegmentTintColor = .whiteWineColor
        case 2:
            wineColorSegmentedControl.selectedSegmentTintColor = .otherWineColor
        default:
            break
        }
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 50 - view.safeAreaInsets.bottom, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: LocalizableText.cameraName, style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        let photo = UIAlertAction(title: LocalizableText.photoName, style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: LocalizableText.cancelText, style: .destructive )
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        save()
        delegate?.updateCurrentBottleInfo()
        if isEdited == true {
            dismiss(animated: true)
        } else {
            performSegue(withIdentifier: "unwindSegue", sender: self)
        }
    }
    
    // Saving object
    func save() {
        let defaultText = ""
        guard let image = bottleImage.image else { return }
        let newBottle = Bottle(name: bottleNameTF.text ?? defaultText,
                               bottleDescription: bottleDescriptionTF.text ?? defaultText,
                               placeOfPurchase: placeOfPurchaseTF.text ?? defaultText,
                               date: time.getData(),
                               bottleImage: bottleImage.image!.pngData(),
                               rating: ratingControl.rating,
                               wineRegion: regionTF.text ?? defaultText,
                               price: priceTF.text ?? defaultText,
                               wineColor: wineColorId,
                               wineType: wineTypeId,
                               wineSugar: wineSugarId,
                               wineSort: wineSortTF.text ?? defaultText,
                               wineCountry: countryTF.text ?? defaultText)
        if currentBottle != nil {
            try! realm.write {
                currentBottle?.bottleImage = newBottle.bottleImage
                currentBottle?.name = newBottle.name
                currentBottle?.bottleDescription = newBottle.bottleDescription
                currentBottle?.placeOfPurchase = newBottle.placeOfPurchase
                currentBottle?.rating = newBottle.rating
                currentBottle?.wineRegion = newBottle.wineRegion
                currentBottle?.price = newBottle.price
                currentBottle?.wineColor = newBottle.wineColor
                currentBottle?.wineType = newBottle.wineType
                currentBottle?.wineSugar = newBottle.wineSugar
                currentBottle?.wineSort = newBottle.wineSort
                currentBottle?.wineCountry = newBottle.wineCountry
                
                wineColorId = currentBottle.wineColor!
                wineTypeId = currentBottle.wineType!
                wineSugarId = currentBottle.wineSugar!
                
                CloudManager.updateCloudData(bottle: currentBottle, bottleImage: image)
            }
        } else {
            CloudManager.saveDataToCloud(bottle: newBottle, bottleImage: image) { recordId in
                DispatchQueue.main.async {
                    try! realm.write {
                        newBottle.recordID = recordId
                    }
                }
            }
            StorageManager.saveObject(newBottle)
        }
        feedbackGenerator.impactOccurred(intensity: 1.0)
    }
    
    @IBAction func wineColorAction(_ sender: Any) {
        switch wineColorSegmentedControl.selectedSegmentIndex {
        case 0:
            wineColorId = 0
            wineColorSegmentedControl.selectedSegmentTintColor = .redWineColor
        case 1:
            wineColorId = 1
            wineColorSegmentedControl.selectedSegmentTintColor = .whiteWineColor
        case 2:
            wineColorId = 2
            wineColorSegmentedControl.selectedSegmentTintColor = .otherWineColor
        default:
            break
        }
    }
    
    @IBAction func wineSugarAction(_ sender: Any) {
        switch wineSugarSegmentedControl.selectedSegmentIndex {
        case 0:
            wineSugarId = 0
        case 1:
            wineSugarId = 1
        case 2:
            wineSugarId = 2
        case 3:
            wineSugarId = 3
        default:
            break
        }
    }
    
    @IBAction func wineTypeAction(_ sender: Any) {
        switch wineTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            wineTypeId = 0
        case 1:
            wineTypeId = 1
        case 2:
            wineTypeId = 2
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanQR" {
            let vc = segue.destination as! QRScannerViewController
            vc.delegate = self
        }
    }
    
}

// MARK: Work with image
extension NewBottleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        bottleImage.image = info[.editedImage] as? UIImage
        bottleImage.contentMode = .scaleAspectFill
        bottleImage.clipsToBounds = true
        dismiss(animated: true)
    }
}

// MARK: UIScrollViewDelegate
extension NewBottleViewController: UIScrollViewDelegate {
    
    // Disable horizontal scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}

extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let tag = 666
        if show {
            self.isEnabled = false
            self.alpha = 1
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.layer.position = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            indicator.color = .white
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}


