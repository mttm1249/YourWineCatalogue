//
//  BottlesCatalogueViewModel.swift
//  Vinishko
//
//  Created by mttm on 02.09.2023.
//

import CoreData
import UIKit

final class BottlesCatalogueViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<Bottle>!
    var managedObjectContext: NSManagedObjectContext
    
    @Published var filteredBottles: [Bottle] = []
    @Published var searchText: String = ""
    @Published var selectedSegment: Int = -1
    @Published var selectedBottle: Bottle? = nil
    
    var allBottles: [Bottle] {
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    var wineSorts: [String] {
        Set(filteredBottles.compactMap { $0.wineSort }.filter { !$0.isEmpty })
        .map { $0.localize() }
        .sorted()
    }

    var placesOfPurchase: [String] {
        Set(filteredBottles.compactMap { $0.placeOfPurchase }.filter { !$0.isEmpty }).sorted()
    }
    
    var wineTypes: [Int16] {
        Set(filteredBottles.compactMap { $0.wineType } ).sorted()
    }
    
    var wineSugar: [Int16] {
        Set(filteredBottles.compactMap { $0.wineSugar } ).sorted()
    }
    
    var wineCountries: [String] {
        Set(filteredBottles.compactMap { $0.wineCountry }.filter { !$0.isEmpty }).sorted()
    }
    
    var wineRegions: [String] {
        Set(filteredBottles.compactMap { $0.wineRegion }.filter { !$0.isEmpty }).sorted()
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
    
    var selectedWineSugar: Int16? {
        didSet {
            applyFilters()
        }
    }
    
    var selectedSorting = 0 {
        didSet {
            applySorting()
        }
    }
    
    var selectedWineRegion: String? {
        didSet {
            applyFilters()
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
    
    func applyFilters() {
        filteredBottles = fetchedResultsController.fetchedObjects?.filter { bottle in
            let isNameMatch = isNameMatching(bottle)
            let isColorMatch = isColorMatching(bottle)
            let isTypeMatch = isTypeMatching(bottle)
            let isSortMatch = isSortMatching(bottle)
            let isPlaceMatch = isPlaceMatching(bottle)
            let isCountryMatch = isCountryMatching(bottle)
            let isRegionMatch = isRegionMatching(bottle)
            let isSugarAmountMatch = isSugarAmountMatching(bottle)
            
            return isNameMatch && isColorMatch && isTypeMatch && isSortMatch && isPlaceMatch && isCountryMatch && isRegionMatch && isSugarAmountMatch
        } ?? []
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
    
    private func isNameMatching(_ bottle: Bottle) -> Bool {
        let lowercasedSearchText = searchText.lowercased()
        guard let bottleName = bottle.name else { return false }
        return lowercasedSearchText.isEmpty ? true : bottleName.lowercased().contains(lowercasedSearchText)
    }
    
    private func isColorMatching(_ bottle: Bottle) -> Bool {
        switch selectedSegment {
        case 0:
            return bottle.wineColor == 0
        case 1:
            return bottle.wineColor == 1
        case 2:
            return bottle.wineColor == 2
        default:
            return true
        }
    }
    
    private func isTypeMatching(_ bottle: Bottle) -> Bool {
        switch selectedType {
        case 0:
            return bottle.wineType == 0
        case 1:
            return bottle.wineType == 1
        case 2:
            return bottle.wineType == 2
        default:
            return true
        }
    }
    
    private func isSugarAmountMatching(_ bottle: Bottle) -> Bool {
        switch selectedWineSugar {
        case 0:
            return bottle.wineSugar == 0
        case 1:
            return bottle.wineSugar == 1
        case 2:
            return bottle.wineSugar == 2
        case 3:
            return bottle.wineSugar == 3
        default:
            return true
        }
    }
    
    private func isSortMatching(_ bottle: Bottle) -> Bool {
        if let selectedSort = selectedWineSort, let wineSort = bottle.wineSort?.localize() {
            return wineSort.contains(selectedSort)
        } else {
            return true
        }
    }
    
    private func isPlaceMatching(_ bottle: Bottle) -> Bool {
        if let selectedPlace = selectedPlace, let placeOfPurchase = bottle.placeOfPurchase {
            return placeOfPurchase.contains(selectedPlace)
        } else {
            return true
        }
    }
    
    private func isCountryMatching(_ bottle: Bottle) -> Bool {
        if let selectedCountry = selectedWineCountry, let wineCountry = bottle.wineCountry {
            return wineCountry.contains(selectedCountry)
        } else {
            return true
        }
    }
    
    private func isRegionMatching(_ bottle: Bottle) -> Bool {
        if let selectedRegion = selectedWineRegion, let wineRegion = bottle.wineRegion {
            return wineRegion.contains(selectedRegion)
        } else {
            return true
        }
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        applyFilters()
    }
}
