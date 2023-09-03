//
//  BottlesCatalogueViewModel.swift
//  Vinishko
//
//  Created by mttm on 02.09.2023.
//

import Foundation
import CoreData

class BottlesCatalogueViewModel: ObservableObject {
    @Published var bottles: [Bottle] = []
    @Published var filteredBottles: [Bottle] = []
    @Published var searchText: String = ""
    @Published var selectedSegment: Int = -1
    var bottleToDelete: Bottle? = nil
    var managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        fetchBottles()
    }
    
    func fetchBottles() {
        let fetchRequest: NSFetchRequest<Bottle> = Bottle.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: true)]
        do {
            self.bottles = try managedObjectContext.fetch(fetchRequest)
            applyFilters()
            print("all bottles: \(bottles)")
            print("all bottles count: \(bottles.count)")
        } catch let error as NSError {
            print("Не удалось извлечь данные. Ошибка: \(error), \(error.userInfo)")
        }
    }

    func applyFilters() {
        let lowercasedSearchText = self.searchText.lowercased()
        filteredBottles = bottles.filter { bottle in
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
            return isNameMatching && isColorMatching
        }
    }
    
    func deleteBottle(_ bottle: Bottle) {
        managedObjectContext.delete(bottle)
        do {
            try managedObjectContext.save()
            fetchBottles()
        } catch {
            print(error.localizedDescription)
        }
    }
}
