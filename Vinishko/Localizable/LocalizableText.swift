//
//  LocalizableText.swift
//  Vinishko
//
//  Created by mttm on 19.11.2023.
//

import Foundation

enum Localizable {
    
    enum UIComponents {
        static let currency = NSLocalizedString("currency", comment: "")
        
        static let searchBar = NSLocalizedString("search_text", comment: "")
        static let cancelButton = NSLocalizedString("cancel_text", comment: "")
        static let сloseButton = NSLocalizedString("close_button", comment: "")
        static let addButton = NSLocalizedString("add_button", comment: "")
        static let clear = NSLocalizedString("clear_button", comment: "")
        static let grapeSortButton = NSLocalizedString("grape_sort_button", comment: "")
        static let countryButton = NSLocalizedString("country_button", comment: "")
        static let regionButton = NSLocalizedString("region_button", comment: "")
        static let ratingBar = NSLocalizedString("rating_bar", comment: "")
        static let withoutRating = NSLocalizedString("without_rating", comment: "")
        static let edit = NSLocalizedString("edit_menu", comment: "")
        static let showQR = NSLocalizedString("show_qr_menu", comment: "")
        static let delete = NSLocalizedString("delete_menu", comment: "")
    }
    
    enum WineColors {
        static let red = NSLocalizedString("red_wineColor", comment: "")
        static let white = NSLocalizedString("white_wineColor", comment: "")
        static let other = NSLocalizedString("other_wineColor", comment: "")
    }
    
    enum WineSugar {
        static let dry = NSLocalizedString("dry_wineSugar", comment: "")
        static let semiDry = NSLocalizedString("semiDry_wineSugar", comment: "")
        static let semiSweet = NSLocalizedString("semiSweet_wineSugar", comment: "")
        static let sweet = NSLocalizedString("sweet_wineSugar", comment: "")
    }
    
    enum WineType {
        static let still = NSLocalizedString("still_wineType", comment: "")
        static let sparkling = NSLocalizedString("sparkling_wineType", comment: "")
        static let other = NSLocalizedString("other_wineType", comment: "")
    }
    
    enum MainScreenModule {
        static let saved = NSLocalizedString("saved_text", comment: "")
        static let alertMigration = NSLocalizedString("records_found", comment: "")
        static let messageText = NSLocalizedString("migration_text", comment: "")
        static let yes = NSLocalizedString("yes", comment: "")
    }
    
    enum NewBottleScreenModule {
        static let selectSource = NSLocalizedString("select_source", comment: "")
        static let camera = NSLocalizedString("camera", comment: "")
        static let gallery = NSLocalizedString("gallery", comment: "")
        static let nameTitle = NSLocalizedString("name_title", comment: "")
        static let place = NSLocalizedString("place_title", comment: "")
        static let price = NSLocalizedString("price_title", comment: "")
        static let comment = NSLocalizedString("comment_title", comment: "")
        static let addWine = NSLocalizedString("add_wine", comment: "")
        static let error = NSLocalizedString("error", comment: "")
        static let ok = NSLocalizedString("ok", comment: "")
    }
    
    enum BottlesCatalogueModule {
        static let filters = NSLocalizedString("filters", comment: "")
        static let empty = NSLocalizedString("empty", comment: "")
        static let deleting = NSLocalizedString("deleting", comment: "")
        static let message = NSLocalizedString("message_alert", comment: "")
        static let delete = NSLocalizedString("delete", comment: "")
        static let cancel = NSLocalizedString("cancel", comment: "")
        static let catalogue = NSLocalizedString("catalogue", comment: "")
        static let statistics = NSLocalizedString("statistics_menu", comment: "")
        static let settingsQR = NSLocalizedString("settingsQR_menu", comment: "")
        static let scan = NSLocalizedString("scan_text", comment: "")
    }
    
    enum BottleDetailsModule {
        static let description = NSLocalizedString("description", comment: "")
        static let origin = NSLocalizedString("wine_origin", comment: "")
        static let purchase = NSLocalizedString("purchase", comment: "")
        static let comment = NSLocalizedString("comment", comment: "")
        static let details = NSLocalizedString("details", comment: "")
        static let scan = NSLocalizedString("scan_text", comment: "")
        static let tastingDate = NSLocalizedString("tasting_date", comment: "")
    }
    
    enum FiltersModule {
        static let sortBy = NSLocalizedString("sort_by", comment: "")
        static let byDate = NSLocalizedString("by_date", comment: "")
        static let byRating = NSLocalizedString("by_rating", comment: "")
        static let byPrice = NSLocalizedString("by_price", comment: "")
        static let bySugar = NSLocalizedString("sort_by_sugar", comment: "")
        static let byType = NSLocalizedString("sort_by_type", comment: "")
        static let byGrape = NSLocalizedString("sort_by_grapeSort", comment: "")
        static let byCountry = NSLocalizedString("sort_by_country", comment: "")
        static let byRegion = NSLocalizedString("sort_by_region", comment: "")
        static let byPurchasePlace = NSLocalizedString("sort_by_purchasePlace", comment: "")
        static let clearAll = NSLocalizedString("clear_all", comment: "")
        static let sortingAndFiltersTitle = NSLocalizedString("sorting_and_filters_title", comment: "")
    }
    
    enum SettingsScreenModule {
        static let sharePhoto = NSLocalizedString("share_photo", comment: "")
        static let shareRating = NSLocalizedString("share_rating", comment: "")
        static let shareComment = NSLocalizedString("share_comment", comment: "")
        static let settingsTitle = NSLocalizedString("settings_qr_title", comment: "")
    }
    
    enum QRCodeScannerModule {
        static let imageError = NSLocalizedString("image_error", comment: "")
        static let information = NSLocalizedString("information", comment: "")
        static let messageText = NSLocalizedString("message_text", comment: "")
        static let ok = NSLocalizedString("ok_button", comment: "")
        static let add = NSLocalizedString("add", comment: "")
        static let cancel = NSLocalizedString("cancel_button", comment: "")
        static let yes = NSLocalizedString("yes_button", comment: "")
    }
    
    enum StatisticsScreenModule {
        static let top = NSLocalizedString("top", comment: "")
        static let showAll = NSLocalizedString("show_all", comment: "")
        static let statisticsTitle = NSLocalizedString("statistics_title", comment: "")
    }
}
