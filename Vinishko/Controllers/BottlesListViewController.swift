//
//  BottlesListViewController.swift
//  Vinishko
//
//  Created by Денис on 01.10.2022.
//

import UIKit
import RealmSwift
import Network

class BottlesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let alertView = UIView()
    var bottles: Results<Bottle>!
    var filteredBottles: Results<Bottle>!
    private let currentLanguage = Locale.current.identifier
    
    private let shared = FilterManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottles = realm.objects(Bottle.self)
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
        setupSearchBar()
        loadFromCloud()
        checkBottlesCount()
    }
                
    private func loadFromCloud() {
        CloudManager.fetchDataFromCloud(bottles: bottles) { (bottle) in
            StorageManager.saveObject(bottle)
            self.tableView.reloadData()
            CloudManager.getImageFromCloud(bottle: bottle, closure: { imageData in
                try! realm.write {
                    bottle.bottleImage = imageData
                }
                self.tableView.reloadData()
            })
        }
    }
    
    private func checkBottlesCount() {
        if currentLanguage != "ru_RU" {
            addBannerWith(alertText: "Empty, add a bottle!")
        } else {
            addBannerWith(alertText: "Тут пока пусто...(")
        }
    }
    
    private func addBannerWith(alertText: String) {
        if bottles.count == 0 {
            alertView.frame = CGRect(x: CGFloat(0), y: tableView.bounds.height / 2 - 80, width: tableView.bounds.width, height: CGFloat(80))
            alertView.backgroundColor = .redWineColor
            
            let alertTextLabel = UILabel()
            alertTextLabel.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: alertView.bounds.width, height: CGFloat(80))
            
            alertTextLabel.textAlignment = .center
            alertTextLabel.font = .systemFont(ofSize: 18, weight: .semibold)
            alertTextLabel.textColor = .white
            alertTextLabel.text = alertText
            
            alertView.addSubview(alertTextLabel)
            tableView.addSubview(alertView)
        }
        delay(1) {
            if self.bottles.count != 0 {
                self.alertView.removeFromSuperview()
            }
        }
    }
    
    fileprivate func delay(_ delay: Double, closure: @escaping() -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            closure()
        }
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "BottleCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "bottleCell")
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        if currentLanguage != "ru_RU" {
            searchController.searchBar.placeholder = "Find bottle by name"
        } else {
            searchController.searchBar.placeholder = "Найти винишко по названию"
        }
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredBottles.count
        }
        return bottles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bottleCell", for: indexPath) as! BottleCell
        let bottle = isFiltering ? filteredBottles.reversed()[indexPath.row] : bottles.reversed()[indexPath.row]
        cell.setup(model: bottle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        tableView.separatorStyle = .none
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var titleText = ""
        var messageText = ""
        var cancelText = ""
        var deleteText = ""
        if currentLanguage != "ru_RU" {
            titleText = "Delete record?"
            messageText = "This record will be deleted from all your devices"
            deleteText = "Delete"
            cancelText = "Cancel"
        } else {
            titleText = "Удалить запись?"
            messageText = "Эта запись будет удалена со всех Ваших устройств"
            deleteText = "Удалить"
            cancelText = "Отмена"
        }
        if editingStyle == .delete {
            let bottle = bottles.reversed()[indexPath.row]
            self.showAlert(title: titleText, message: messageText, deleteText: deleteText, cancelText: cancelText) {
                CloudManager.deleteRecord(recordID: bottle.recordID)
                StorageManager.deleteObject(bottle)
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "bottleVC") as? BottleViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let bottle = isFiltering ? filteredBottles.reversed()[indexPath.row] : bottles.reversed()[indexPath.row]
        editVC.currentBottle = bottle
        editVC.delegate = self
        editVC.modalPresentationStyle = .pageSheet
        present(editVC, animated: true)
    }
    
    // Delegate method
    func updateCurrentBottleInfo() {
        tableView.reloadData()
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "filter", sender: nil)
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        bottles = realm.objects(Bottle.self)
        if shared.colorIdOptionInfo != nil && shared.colorIdOptionInfo != 9 {
            let filtered = bottles.where { $0.wineColor == shared.colorIdOptionInfo }
            bottles = filtered
        }
        if shared.placeOfPurchaseOptionInfo != nil {
            let filtered = bottles.where { $0.placeOfPurchase == shared.placeOfPurchaseOptionInfo }
            bottles = filtered
        }
        if shared.countryOptionInfo != nil {
            let filtered = bottles.where { $0.wineCountry == shared.countryOptionInfo }
            bottles = filtered
        }
        tableView.reloadData()
    }
    
    private func showAlert(title: String, message: String, deleteText: String, cancelText: String, closure: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: deleteText, style: .destructive) { (_) in
            closure()
        }
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

// MARK: Searching
extension BottlesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredBottles = bottles.filter("name CONTAINS[cd] %@", searchText)
        tableView.reloadData()
    }
}

extension BottlesListViewController: UpdateBottlesList {
    func updateTableView() {
        tableView.reloadData()
    }
    
}
