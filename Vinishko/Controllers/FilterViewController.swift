//
//  FilterViewController.swift
//  Vinishko
//
//  Created by Денис on 05.10.2022.
//

import UIKit
import RealmSwift

class FilterViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var bottles: Results<Bottle>!
    private let shared = FilterManager.shared
    
    @IBOutlet weak var bottlesCounter: UILabel!
    @IBOutlet weak var redBottlesCounter: UILabel!
    @IBOutlet weak var whiteBottlesCounter: UILabel!
    @IBOutlet weak var otherBottlesCounter: UILabel!
    @IBOutlet weak var filterByColorButton: UIButton!
    @IBOutlet weak var filterByPlaceOfPurchaseButton: UIButton!
    @IBOutlet weak var filterByCountryButton: UIButton!
    
    @IBOutlet weak var cancelColorButton: UIButton!
    @IBOutlet weak var cancelPurchaseButton: UIButton!
    @IBOutlet weak var cancelCountryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottles = realm.objects(Bottle.self)
        setupStatistics()
        setupButtonTitles()
    }
        
    private func setupStatistics() {
        bottlesCounter.text = "Всего выпито: \(bottles.count)"
        let redWine = bottles.filter { $0.wineColor == 0 }
        redBottlesCounter.text = "Красного: \(redWine.count)"
        let whiteWine = bottles.filter { $0.wineColor == 1 }
        whiteBottlesCounter.text = "Белого: \(whiteWine.count)"
        let otherWine = bottles.filter { $0.wineColor == 2 }
        otherBottlesCounter.text = "Других: \(otherWine.count)"
    }
    
    private func setupButtonTitles() {
        // setup colorButton
        switch shared.colorIdOptionInfo {
        case 0:
            filterByColorButton.setTitle("Красные", for: .normal)
        case 1:
            filterByColorButton.setTitle("Белые", for: .normal)
        case 2:
            filterByColorButton.setTitle("Другие", for: .normal)
        default:
            break
        }
   
        // setup placeOfPurchaseButton
        if shared.placeOfPurchaseOptionInfo != nil {
            filterByPlaceOfPurchaseButton.setTitle(shared.placeOfPurchaseOptionInfo, for: .normal)
        }
        
        // setup countryButton
        if shared.countryOptionInfo != nil {
            filterByCountryButton.setTitle(shared.countryOptionInfo, for: .normal)
        }
    }
    
    @IBAction func cancelAllButtonAction(_ sender: Any) {
        shared.colorIdOptionInfo = nil
        shared.placeOfPurchaseOptionInfo = nil
        shared.countryOptionInfo = nil
        
        filterByColorButton.setTitle("Цвет", for: .normal)
        filterByPlaceOfPurchaseButton.setTitle("Место покупки", for: .normal)
        filterByCountryButton.setTitle("Страна", for: .normal)
    }
    
    func delay(_ delay: Double, closure: @escaping() -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            closure()
        }
    }
    
    @IBAction func cancelOptionButtonAction(_ sender: Any) {
        let tag = (sender as AnyObject).tag
        
        switch tag {
        case 0:
            shared.colorIdOptionInfo = nil
            filterByColorButton.setTitle("Цвет", for: .normal)
        case 1:
            shared.placeOfPurchaseOptionInfo = nil
            filterByPlaceOfPurchaseButton.setTitle("Место покупки", for: .normal)
        case 2:
            shared.countryOptionInfo = nil
            filterByCountryButton.setTitle("Страна", for: .normal)
        default:
            break
        }
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        guard let popoverTableViewController = storyboard?.instantiateViewController(withIdentifier: "popoverTableView") as? PopoverTableViewController else { return }
        popoverTableViewController.modalPresentationStyle = .popover
        popoverTableViewController.delegate = self
        let popover = popoverTableViewController.popoverPresentationController
        popover?.delegate = self
        
        let tag = (sender as AnyObject).tag
        
        switch tag {
        case 0:
            popover?.sourceView = filterByColorButton
            popover?.sourceRect = CGRect(x: filterByColorButton.bounds.midX, y: filterByColorButton.bounds.midY, width: 0, height: 0)
            popoverTableViewController.optionsArrayId = tag
        case 1:
            popover?.sourceView = filterByPlaceOfPurchaseButton
            popover?.sourceRect = CGRect(x: filterByPlaceOfPurchaseButton.bounds.midX, y: filterByPlaceOfPurchaseButton.bounds.midY, width: 0, height: 0)
            popoverTableViewController.optionsArrayId = tag
        case 2:
            popover?.sourceView = filterByCountryButton
            popover?.sourceRect = CGRect(x: filterByCountryButton.bounds.midX, y: filterByCountryButton.bounds.midY, width: 0, height: 0)
            popoverTableViewController.optionsArrayId = tag
        default:
            break
        }
        
        popoverTableViewController.preferredContentSize = CGSize(width: 200, height: 200)
        present(popoverTableViewController, animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

// MARK: Titles for buttons setting up
extension FilterViewController: FilterOptionsProtocol {
    func getOptionName(name: String, tag: Int) {
        switch tag {
        case 0:
            filterByColorButton.setTitle(name, for: .normal)
        case 1:
            filterByPlaceOfPurchaseButton.setTitle(name, for: .normal)
        case 2:
            filterByCountryButton.setTitle(name, for: .normal)
        default:
            break
        }
        
    }
    
    func getColorOption(colorId: Int) {
    }
    
}
