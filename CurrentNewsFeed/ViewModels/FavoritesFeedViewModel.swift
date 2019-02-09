//
//  FavoritesFeedViewModel.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 09/02/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import CoreData

class FavoritesFeedViewModel: NSObject {
    
    weak var delegate: FavoritesViewModelDelegate?
    
    lazy var fetchedResultController: NSFetchedResultsController<Favorite> = {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "savedOn", ascending: false)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request, managedObjectContext: DataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        return controller
    }()
    
    var favoritesCount: Int {
        guard let objects = self.fetchedResultController.fetchedObjects else { return 0 }
        
        return objects.count
    }
    
    override init() {
        super.init()
        
        do {
            try self.fetchedResultController.performFetch()
        } catch let fetchError {
            print(fetchError.localizedDescription)
        }
    }
    
    func favorite(at indexPath: IndexPath) -> Favorite {
        return self.fetchedResultController.object(at: indexPath)
    }
    
    func removeFavorite(at indexPath: IndexPath) {
        let favorite = self.fetchedResultController.object(at: indexPath)
        DataManager.context.delete(favorite)
    }
    
}

// MARK: - NSFetchedResultsController delegate implementation.
extension FavoritesFeedViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath, let favorite = anObject as? Favorite else { return }
            self.delegate?.favoriteRemoved(favorite, at: indexPath)
        default:
            return
        }
        
    }
    
}
