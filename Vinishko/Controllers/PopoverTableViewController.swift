//
//  PopoverTableViewController.swift
//  Vinishko
//
//  Created by Денис on 05.10.2022.
//


import UIKit
import RealmSwift

protocol FilterOptionsProtocol: AnyObject {
    func getColorOption(colorId: Int)
    func getOptionName(name: String, tag: Int)
}

class PopoverTableViewController: UITableViewController {
    
    var optionsArrayId: Int?
    private var options: [String] = []
    weak var delegate: FilterOptionsProtocol?
    var bottles: Results<Bottle>!
    private let shared = FilterManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottles = realm.objects(Bottle.self)
        
        switch optionsArrayId {
        case 0:
            options = ["Красные", "Белые", "Другие"]
        case 1:
            for bottle in bottles {
                guard bottle.placeOfPurchase != nil else { return }
                let purchaseInfo = bottle.placeOfPurchase!
                if !options.contains(purchaseInfo) { options.append(purchaseInfo) }
            }
        case 2:
            for bottle in bottles {
                guard bottle.wineCountry != nil else { return }
                let countryInfo = bottle.wineCountry!
                if !options.contains(countryInfo) { options.append(countryInfo) }
            }
        default:
            break
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionName = options[indexPath.row]
        var colorId: Int?
        switch optionsArrayId {
        case 0:
            switch indexPath {
            case [0, 0]:
                colorId = 0
            case [0, 1]:
                colorId = 1
            case [0, 2]:
                colorId = 2
            default:
                break
            }
            delegate?.getColorOption(colorId: colorId!)
            delegate?.getOptionName(name: optionName, tag: 0)
            shared.colorIdOptionInfo = colorId!
        case 1:
            delegate?.getOptionName(name: optionName, tag: 1)
            shared.placeOfPurchaseOptionInfo = optionName
        case 2:
            delegate?.getOptionName(name: optionName, tag: 2)
            shared.countryOptionInfo = optionName
        default:
            break
        }
        dismiss(animated: true)
    }
}

