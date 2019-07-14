//
//  NewsFeedViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 17/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

final class NewsFeedViewController: UIViewController {

    // MARK: - Properties
    var coordinator: NewsFeedCoordinator?
    var selectedAPIEndpoint: APIEndpoints?

    let itemsFeedView = ItemsFeedView()
    let apiHandler = APIHandler()

    var loadedNews: [Item] = [] {
        didSet {
            self.itemsFeedView.feedTableView.reloadData()
        }
    }

    // MARK: - Lifecycle
    override func loadView() {
        self.view = self.itemsFeedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        
        self.itemsFeedView.feedTableView.delegate = self
        self.itemsFeedView.feedTableView.dataSource = self
        
        // Default settings for the loading message.
        self.itemsFeedView.loadingMessageLabel.text = "Loading Stories..."
        self.itemsFeedView.loadingMessageLabel.textAlignment = .center
        
        // First load.
        self.checkFeedUpdates()
        
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.itemsFeedView.feedTableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkFeedUpdates()
    }
    
    
    /// Updates the data displayed in the tableview. Before that,
    /// it does the necessary checks for the api requests.
    private func checkFeedUpdates() {
        let defaults = UserDefaults.standard
        let saved = defaults.integer(forKey: "MainFeedURL")
        
        guard let selected = APIEndpoints(rawValue: saved) else { return }
        
        if selected != self.selectedAPIEndpoint {
            self.selectedAPIEndpoint = selected
            self.navigationItem.title = selected.info.label
            self.loadedNews = []
            
            self.apiHandler.listOfStories(from: selected.info.endpoint) { news in
                DispatchQueue.main.async {
                    self.loadedNews = news
                    self.itemsFeedView.feedTableView.reloadData()
                }
            }
        }
    }

}

// MARK: - FeedTableView delegate and data source implementation.
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count " , self.loadedNews.count)
        let count = self.loadedNews.count
        tableView.backgroundView = count == 0 ? self.itemsFeedView.loadingMessageLabel : nil
    
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NewsFeedCell", for: indexPath) as? NewsFeedTableViewCell else {
            fatalError("The dequeued cell is not an instance of NewsFeedTableViewCell.")
        }
        
        let current = self.loadedNews[indexPath.row]
        cell.configureCell(item: current)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.loadedNews[indexPath.row]
        self.coordinator?.showDetails(of: item)
    }
}

// MARK: - UIViewControllerPreviewingDelegate implementation.
extension NewsFeedViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.itemsFeedView.feedTableView.indexPathForRow(at: location),
            let cell = self.itemsFeedView.feedTableView.cellForRow(at: indexPath) else { return nil }
        
        guard let itemViewController = storyboard?.instantiateViewController(
            withIdentifier: "ItemViewController") as? ItemViewController else { return nil }
        
        let item = self.loadedNews[indexPath.row]
        itemViewController.item = item
        itemViewController.preferredContentSize = CGSize(width: 0.0, height: 320)
        previewingContext.sourceRect = cell.frame
        
        return itemViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
