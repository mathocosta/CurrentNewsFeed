//
//  ItemViewModel.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 09/02/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import Foundation

class ItemViewModel {
    // MARK: - Instance Properties
    let apiHandler: APIHandler
    
    private let item: Item
    private let authorText: String
    private let publishedDate: Date
    
    let hasKids: Bool
    let titleText: String
    var fetchedKids: [Item]
    
    var subtitleText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm"
        
        return "by \(self.authorText), at \(formatter.string(from: item.published))"
    }
    
    init(item: Item) {
        self.apiHandler = APIHandler()
        self.item = item
        
        self.authorText = item.author ?? ""
        self.titleText = item.title ?? ""
        self.publishedDate = item.published
        self.hasKids = item.kids != nil
        self.fetchedKids = [Item]()
    }

    func fetchKids(_ completion: @escaping (Bool) -> Void) {
        guard let kids = self.item.kids else {
            completion(false)
            return
        }
        
        self.apiHandler.items(from: kids) { items in
            self.fetchedKids = items
            completion(true)
        }
    }
    
    func saveAsFavorite() {
        let favorite = Favorite(context: DataManager.context)
        favorite.title = self.item.title
        favorite.type = self.item.type
        favorite.url = self.item.url
        favorite.published = self.item.published
        favorite.savedOn = Date()
        
        DataManager.saveContext()
    }
}
