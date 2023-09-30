//
//  BottlesCatalogueViewModel.swift
//  Vinishko
//
//  Created by mttm on 02.09.2023.
//

import CoreData
import UIKit

class BottlesCatalogueViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<Bottle>!
    var managedObjectContext: NSManagedObjectContext
    
    @Published var filteredBottles: [Bottle] = []
    @Published var searchText: String = ""
    @Published var selectedSegment: Int = -1
    @Published var bottleToDelete: Bottle? = nil
    
    var wineSorts: [String] {
        Set(filteredBottles.compactMap { $0.wineSort } ).sorted()
    }
    
    var placesOfPurchase: [String] {
        Set(filteredBottles.compactMap { $0.placeOfPurchase } ).sorted()
    }
    
    var wineTypes: [Int16] {
        Set(filteredBottles.compactMap { $0.wineType } ).sorted()
    }
    
    var wineCountries: [String] {
        Set(filteredBottles.compactMap { $0.wineCountry } ).sorted()
    }
    
    var selectedWineSort: String? {
        didSet {
            applyFilters()
        }
    }
    
    var selectedWineCountry: String? {
        didSet {
            applyFilters()
        }
    }
    
    var selectedPlace: String? {
        didSet {
            applyFilters()
        }
    }
    
    var selectedType: Int16? {
        didSet {
            applyFilters()
        }
    }
    
    var selectedSorting = 0 {
        didSet {
            applySorting()
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        super.init()
        setupFetchedResultsController()
        applyFilters()
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Bottle> = Bottle.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Не удалось извлечь данные. Ошибка: \(error), \(error.userInfo)")
        }
    }
    
     func applySorting() {
        let sortedBottles: [Bottle]
        switch selectedSorting {
        case 0:
            sortedBottles = filteredBottles.sorted { (bottle1, bottle2) in
                if let date1 = bottle1.createDate, let date2 = bottle2.createDate {
                    return date1 > date2
                } else {
                    return false
                }
            }
        case 1:
            sortedBottles = filteredBottles.sorted { (bottle1, bottle2) in
                let doubleRating1 = bottle1.doubleRating
                let doubleRating2 = bottle2.doubleRating
                return doubleRating1 > doubleRating2
            }
        case 2:
            sortedBottles = filteredBottles.sorted { (bottle1, bottle2) in
                if let price1 = bottle1.price, let price2 = bottle2.price {
                    return price1 < price2
                } else {
                    return false
                }
            }
        default:
            sortedBottles = filteredBottles
        }
        self.filteredBottles = sortedBottles
    }

    func applyFilters() {
        let lowercasedSearchText = searchText.lowercased()
        filteredBottles = fetchedResultsController.fetchedObjects?.filter { bottle in
            guard let bottleName = bottle.name else { return false }
            
            let isNameMatching = lowercasedSearchText.isEmpty ? true : bottleName.lowercased().contains(lowercasedSearchText)
            
            let isColorMatching: Bool
            switch selectedSegment {
            case 0:
                isColorMatching = (bottle.wineColor == 0)
            case 1:
                isColorMatching = (bottle.wineColor == 1)
            case 2:
                isColorMatching = (bottle.wineColor == 2)
            default:
                isColorMatching = true
            }
            
            let isTypeMatching: Bool
            switch selectedType {
            case 0:
                isTypeMatching = (bottle.wineType == 0)
            case 1:
                isTypeMatching = (bottle.wineType == 1)
            case 2:
                isTypeMatching = (bottle.wineType == 2)
            default:
                isTypeMatching = true
            }
            
            let isSortMatching: Bool
            if let selectedSort = selectedWineSort, let wineSort = bottle.wineSort {
                isSortMatching = wineSort.contains(selectedSort)
            } else {
                isSortMatching = true
            }
            
            let isPlaceMatching: Bool
            if let selectedPlace = selectedPlace, let placeOfPurchase = bottle.placeOfPurchase {
                isPlaceMatching = placeOfPurchase.contains(selectedPlace)
            } else {
                isPlaceMatching = true
            }
            
            let isCountryMatching: Bool
            if let selectedCountry = selectedWineCountry, let wineCountry = bottle.wineCountry {
                isCountryMatching = wineCountry == selectedCountry
            } else {
                isCountryMatching = true
            }
            
            return isNameMatching && isColorMatching && isSortMatching && isPlaceMatching && isTypeMatching && isCountryMatching
        } ?? []
    }
    
    // NSFetchedResultsControllerDelegate method for autoupdate ui
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        applyFilters()
    }
    
    func deleteBottle(_ bottle: Bottle) {
        managedObjectContext.delete(bottle)
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getBottleImage(for bottle: Bottle) -> UIImage {
        if let bottleImageData = bottle.bottleImage, let bottleImage = UIImage(data: bottleImageData) {
            return bottleImage
        } else {
            return UIImage(named: "wine") ?? UIImage()
        }
    }
}
