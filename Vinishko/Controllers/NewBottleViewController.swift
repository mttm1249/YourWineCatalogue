//
//  MainViewController.swift
//  Vinishko
//
//  Created by Денис on 01.10.2022.
//

import UIKit
import Network
import AVFoundation
import PhotosUI

protocol UpdateTableView: AnyObject {
    func updateCurrentBottleInfo()
}

class NewBottleViewController: UIViewController, UpdateFromQR {
    
    weak var delegate: UpdateTableView?
    var currentBottle: Bottle!
    var isEdited: Bool?
    private let monitor = NWPathMonitor()
    private let textScanner = TextScanner()
    
    private var wineColorId = 0
    private var wineTypeId = 0
    private var wineSugarId = 0
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottleImage: UIImageView!
    @IBOutlet weak var bottleNameTF: UITextField!
    @IBOutlet weak var bottleDescriptionTV: CustomTextView!
    @IBOutlet weak var bottleDescriptionHeightConstraint: NSLayoutConstraint!
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
        activityIndicator.isHidden = true
        checkConnection()
        scrollView.delegate = self
        hideKeyboard()
        setupEditScreen()
        bottleDescriptionTV.setup(bottleDescriptionHeightConstraint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBottleDescriptionTextViewHeight()
    }
    
    private func updateBottleDescriptionTextViewHeight() {
        let fixedWidth = bottleDescriptionTV.frame.size.width
        let newSize = bottleDescriptionTV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        bottleDescriptionHeightConstraint.constant = newSize.height
    }
    
    // QR Delegate method
    func updateBottleInfo(string: String) {
        if let result = try? JSONDecoder().decode(QRModel.self, from: Data(string.utf8)) {
            guard result.verification == "VinishkoAPP" else { return }
            fetchImage(from: result.imageURL)
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
            bottleDescriptionTV.text = result.bottleDescription
            ratingControl.rating = result.rating
            setupWineColorSegments(section: result.wineColor)
        }
    }
    
    func fetchImage(from url: String) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        NetworkManager.downloadImage(url: url) { (image) in
            self.activityIndicator.stopAnimating()
            self.bottleImage.image = image
            self.bottleImage.contentMode = .scaleAspectFill
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        bottleImage.isUserInteractionEnabled = true
        bottleImage.addGestureRecognizer(tapGestureRecognizer)
        
        // White color for wine color selector
        wineColorSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
                
        if let currentBottle = currentBottle {
            guard let data = currentBottle.bottleImage, let image = UIImage(data: data) else { return }
            
            bottleImage.image = image
            bottleImage.contentMode = .scaleAspectFill
            bottleNameTF.text = currentBottle.name
            placeOfPurchaseTF.text = currentBottle.placeOfPurchase
            countryTF.text = currentBottle.wineCountry
            regionTF.text = currentBottle.wineRegion
            priceTF.text = currentBottle.price
            ratingControl.rating = currentBottle.rating
            wineSortTF.text = currentBottle.wineSort
            
            wineColorSegmentedControl.selectedSegmentIndex = currentBottle.wineColor ?? 0
            setupWineColorSegments(section: currentBottle.wineColor ?? 0)
            
            wineTypeSegmentedControl.selectedSegmentIndex = currentBottle.wineType ?? 0
            wineSugarSegmentedControl.selectedSegmentIndex = currentBottle.wineSugar ?? 0
            wineColorId = currentBottle.wineColor ?? 0
            wineTypeId = currentBottle.wineType ?? 0
            wineSugarId = currentBottle.wineSugar ?? 0
            
            if let description = currentBottle.bottleDescription, !description.isEmpty {
                bottleDescriptionTV.text = description
                bottleDescriptionHeightConstraint.constant = bottleDescriptionTV.contentSize.height
                bottleDescriptionTV.textColor = .black
            } else {
                bottleDescriptionTV.text = LocalizableText.enterComment
                bottleDescriptionHeightConstraint.constant = bottleDescriptionTV.contentSize.height
                bottleDescriptionTV.textColor = #colorLiteral(red: 0.7764703631, green: 0.7764707804, blue: 0.7850785851, alpha: 1)
            }
        } else {
            bottleDescriptionTV.text = LocalizableText.enterComment
            bottleDescriptionHeightConstraint.constant = bottleDescriptionTV.contentSize.height
            bottleDescriptionTV.textColor = #colorLiteral(red: 0.7764703631, green: 0.7764707804, blue: 0.7850785851, alpha: 1)
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
    
    @objc func imageTapped() {
        presentImagePickerOptions()
    }
    
    func presentImagePickerOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: LocalizableText.cameraName, style: .default) { [weak self] (_) in
                self?.presentImagePicker(sourceType: .camera)
            }
            alertController.addAction(cameraAction)
        }
        
        let galleryAction = UIAlertAction(title: LocalizableText.photoName, style: .default) { [weak self] (_) in
            self?.presentImagePicker(sourceType: .photoLibrary)
        }
        alertController.addAction(galleryAction)
        
        let cancelAction = UIAlertAction(title: LocalizableText.cancelText, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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
    private func save() {
        let defaultText = ""
        guard let image = bottleImage.image else { return }
        let bottleDescription = bottleDescriptionTV.text == LocalizableText.enterComment ? defaultText : (bottleDescriptionTV.text ?? defaultText)
        
        let newBottle = Bottle(name: bottleNameTF.text ?? defaultText,
                               bottleDescription: bottleDescription,
                               placeOfPurchase: placeOfPurchaseTF.text ?? defaultText,
                               date: Time.getDate(),
                               bottleImage: bottleImage.image!.pngData(),
                               rating: ratingControl.rating,
                               wineRegion: regionTF.text ?? defaultText,
                               price: priceTF.text ?? defaultText,
                               wineColor: wineColorId,
                               wineType: wineTypeId,
                               wineSugar: wineSugarId,
                               wineSort: wineSortTF.text ?? defaultText,
                               wineCountry: countryTF.text ?? defaultText)
        
        if let currentBottle = currentBottle {
            try! realm.write {
                currentBottle.bottleImage = newBottle.bottleImage
                currentBottle.name = newBottle.name
                currentBottle.bottleDescription = newBottle.bottleDescription
                currentBottle.placeOfPurchase = newBottle.placeOfPurchase
                currentBottle.rating = newBottle.rating
                currentBottle.wineRegion = newBottle.wineRegion
                currentBottle.price = newBottle.price
                currentBottle.wineColor = newBottle.wineColor
                currentBottle.wineType = newBottle.wineType
                currentBottle.wineSugar = newBottle.wineSugar
                currentBottle.wineSort = newBottle.wineSort
                currentBottle.wineCountry = newBottle.wineCountry
                
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
    
    @IBAction func showQRScannerAction(_ sender: Any) {
        performSegue(withIdentifier: "scanQR", sender: self)
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

//// MARK: UITextViewDelegate
//extension NewBottleViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == LocalizableText.enterComment {
//            textView.text = ""
//            textView.textColor = .black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = LocalizableText.enterComment
//            textView.textColor = #colorLiteral(red: 0.7764703631, green: 0.7764707804, blue: 0.7850785851, alpha: 1)
//        }
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        let fixedWidth = textView.frame.size.width
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        bottleDescriptionHeightConstraint.constant = newSize.height
//        view.layoutIfNeeded()
//    }
//}

// MARK: UIImagePickerControllerDelegate
extension NewBottleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension NewBottleViewController: PHPickerViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            bottleImage.image = image
            self.textScanner.recognizeText(from: image) { recognizedText in
                if let text = recognizedText {
                    self.bottleNameTF.text = text
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else {
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            DispatchQueue.main.async {
                if let image = object as? UIImage {
                    self?.bottleImage.image = image
                }
            }
        }
    }
}
