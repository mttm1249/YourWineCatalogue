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
    
    var selectedWineSort: String? {
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
            
            return isNameMatching && isColorMatching && isSortMatching && isPlaceMatching && isTypeMatching
        } ?? []
    }
    
    // NSFetchedResultsControllerDelegate
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
