//
//  FavoritesFeedViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 18/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

class FavoritesFeedViewController: UIViewController {
    
    var favoritesViewModel: FavoritesFeedViewModel!
    
    var emptyMessageLabel = UILabel()
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        self.favoritesTableView.register(
            UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoritesFeedCell")
        
        // Default settings for the empty favorites list label.
        self.emptyMessageLabel.text = "Não há favoritos adicionados"
        self.emptyMessageLabel.textAlignment = .center
        
        self.favoritesViewModel = FavoritesFeedViewModel()
        self.favoritesViewModel.delegate = self
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayItemSegue" {
            guard let destination = segue.destination as? ItemViewController,
                let indexPath = sender as? IndexPath else { return }
            
            let favorite = self.favoritesViewModel.favorite(at: indexPath)
            
            destination.cellIndexPath = indexPath
            destination.itemViewModel = ItemViewModel(item: Item(from: favorite))
            destination.delegate = self
            destination.hidesBottomBarWhenPushed = true
        }
    }
}

// MARK: - FeedTableView delegate and data source implementation.
extension FavoritesFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfFavorites = self.favoritesViewModel.favoritesCount
        print("favorites count " , numberOfFavorites)
        self.favoritesTableView.backgroundView = numberOfFavorites == 0 ? self.emptyMessageLabel : nil

        return numberOfFavorites
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesFeedCell", for: indexPath) as? FeedTableViewCell else {
            fatalError("The dequeued cell is not an instance of NewsFeedTableViewCell.")
        }

        let current = self.favoritesViewModel.favorite(at: indexPath)
        let item = Item(from: current)
        cell.configureCell(item: item)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.favoritesViewModel.removeFavorite(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DisplayItemSegue", sender: indexPath)
    }
    
}

// MARK: - ItemViewController delegate implementation.
extension FavoritesFeedViewController: ItemViewControllerDelegate {
    
    func itemDeleted(_ item: ItemViewModel, at position: IndexPath) {
        self.favoritesViewModel.removeFavorite(at: position)
    }
    
}

// MARK: - FavoritesViewModel delegate implementation
extension FavoritesFeedViewController: FavoritesViewModelDelegate {
    
    func favoriteRemoved(_ favorite: Favorite, at indexPath: IndexPath) {
        self.favoritesTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}
