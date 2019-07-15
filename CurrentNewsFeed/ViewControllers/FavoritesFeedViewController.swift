//
//  FavoritesFeedViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 18/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit
import CoreData

final class FavoritesFeedViewController: UIViewController {

    // MARK: - Properties

    var coordinator: FavoritesFeedCoordinator?

    lazy var fetchedResultController: NSFetchedResultsController<Favorite> = {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "savedOn", ascending: false)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request, managedObjectContext: DataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        return controller
    }()

    let itemsFeedView = ItemsFeedView()

    // MARK: - Lifecycle

    override func loadView() {
        self.view = self.itemsFeedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Favorites"
        
        self.itemsFeedView.feedTableView.delegate = self
        self.itemsFeedView.feedTableView.dataSource = self
        
        // Default settings for the empty favorites list label.
        self.itemsFeedView.messageLabel.text = "No favorites added"
        
        do {
            try self.fetchedResultController.performFetch()
        } catch let fetchError {
            print(fetchError.localizedDescription)
        }
    }

}

// MARK: - FeedTableView delegate and data source implementation.
extension FavoritesFeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let favorites = self.fetchedResultController.fetchedObjects else {
            return 0
        }
        print("favorites count " , favorites.count)
        tableView.backgroundView = favorites.count == 0 ? self.itemsFeedView.messageLabel : nil

        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NewsFeedCell", for: indexPath) as? NewsFeedTableViewCell else {
            fatalError("The dequeued cell is not an instance of NewsFeedTableViewCell.")
        }

        let current = self.fetchedResultController.object(at: indexPath)
        let item = Item(from: current)
        cell.configureCell(item: item)

        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favorite = self.fetchedResultController.object(at: indexPath)
            DataManager.context.delete(favorite)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = self.fetchedResultController.object(at: indexPath)
        let item = Item(from: favorite)
        self.coordinator?.showDetails(of: item)
    }

}

// MARK: - ItemViewController delegate implementation.
extension FavoritesFeedViewController: ItemViewControllerDelegate {
    func itemDeleted(_ item: Item, at position: IndexPath) {
        let favorite = self.fetchedResultController.object(at: position)

        DataManager.context.delete(favorite)
    }
}

// MARK: - NSFetchedResultsController delegate implementation.
extension FavoritesFeedViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                self.itemsFeedView.feedTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            self.itemsFeedView.feedTableView.reloadData()
        }
    }

}
