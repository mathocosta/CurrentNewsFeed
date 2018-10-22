//
//  FavoritesFeedViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 18/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit
import CoreData

class FavoritesFeedViewController: UIViewController {
    lazy var fetchedResultController: NSFetchedResultsController<Favorite> = {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "savedOn", ascending: false)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request, managedObjectContext: DataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        return controller
    }()
    
    var emptyMessageLabel = UILabel()
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        self.favoritesTableView.register(
            UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsFeedCell")
        
        // Default settings for the empty favorites list label.
        self.emptyMessageLabel.text = "Não há favoritos adicionados"
        self.emptyMessageLabel.textAlignment = .center
        
        do {
            try self.fetchedResultController.performFetch()
        } catch let fetchError {
            print(fetchError.localizedDescription)
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayItemSegue" {
            guard let destination = segue.destination as? ItemViewController,
                let favorite = sender as? Favorite else { return }
            
            destination.item = Item(from: favorite)
            destination.hidesBottomBarWhenPushed = true
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
        self.favoritesTableView.backgroundView = favorites.count == 0 ? self.emptyMessageLabel : nil

        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath) as? NewsFeedTableViewCell else {
            fatalError("The dequeued cell is not an instance of NewsFeedTableViewCell.")
        }

        let current = self.fetchedResultController.object(at: indexPath)
        let item = Item(from: current)
        cell.configureCell(item: item)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favorite = self.fetchedResultController.object(at: indexPath)
            DataManager.context.delete(favorite)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DisplayItemSegue", sender: self.fetchedResultController.object(at: indexPath))
    }
}

// MARK: - NSFetchedResultsController delegate implementation.
extension FavoritesFeedViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                self.favoritesTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            self.favoritesTableView.reloadData()
        }
    }
}
