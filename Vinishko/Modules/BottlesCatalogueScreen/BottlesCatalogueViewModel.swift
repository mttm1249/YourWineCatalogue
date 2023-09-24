//
//  BottlesCatalogueViewModel.swift
//  Vinishko
//
//  Created by mttm on 02.09.2023.
//

import CoreData
import UIKit

class BottlesCatalogueViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    @Published var filteredBottles: [Bottle] = []
    @Published var searchText: String = ""
    @Published var selectedSegment: Int = -1
    @Published var isLoading: Bool = false
    var bottleToDelete: Bottle? = nil
    var managedObjectContext: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<Bottle>!
    
    var wineSorts: [String] {
        Set(fetchedResultsController.fetchedObjects?.compactMap { $0.wineSort } ?? []).sorted()
    }
    
    @Published var selectedWineSort: String? {
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
    
    func setupFetchedResultsController() {
        isLoading = true // начинаем загрузку
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
            isLoading = false // завершаем загрузку
        } catch let error as NSError {
            print("Не удалось извлечь данные. Ошибка: \(error), \(error.userInfo)")
            isLoading = false // завершаем загрузку, даже если произошла ошибка
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
            
            let isSortMatching: Bool
            if let selectedSort = selectedWineSort, let wineSort = bottle.wineSort {
                isSortMatching = wineSort.contains(selectedSort)
            } else {
                isSortMatching = true
            }
            
            return isNameMatching && isColorMatching && isSortMatching
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
