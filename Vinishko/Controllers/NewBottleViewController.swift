//
//  MainViewController.swift
//  Vinishko
//
//  Created by Денис on 01.10.2022.
//

import UIKit

protocol UpdateTableView: AnyObject {
    func updateCurrentBottleInfo()
}

class NewBottleViewController: UIViewController {
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    weak var delegate: UpdateTableView?
    var currentBottle: Bottle!
    var isEdited: Bool?
    private let time = Time()
    
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
        scrollView.delegate = self
        hideKeyboard()
        setupEditScreen()
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
            
            switch currentBottle.wineColor {
            case 0:
                wineColorSegmentedControl.selectedSegmentTintColor = .redWineColor
            case 1:
                wineColorSegmentedControl.selectedSegmentTintColor = .whiteWineColor
            case 2:
                wineColorSegmentedControl.selectedSegmentTintColor = .otherWineColor
            case .none:
                break
            case .some(_):
                break
            }
            
            wineTypeSegmentedControl.selectedSegmentIndex = currentBottle.wineType!
            wineSugarSegmentedControl.selectedSegmentIndex = currentBottle.wineSugar!
            wineColorId = currentBottle.wineColor!
            wineTypeId = currentBottle.wineType!
            wineSugarId = currentBottle.wineSugar!
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
        let currentLanguage = Locale.current.identifier
       
        var cameraName = ""
        var photoName = ""
        var cancelName = ""
        
        if currentLanguage != "ru_RU" {
            cameraName = "Camera"
            photoName = "PhotoLibrary"
            cancelName = "Cancel"
        } else {
            cameraName = "Камера"
            photoName = "Галерея"
            cancelName = "Отмена"
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: cameraName, style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        let photo = UIAlertAction(title: photoName, style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: cancelName, style: .destructive )
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
        feedbackGenerator.impactOccurred()
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
