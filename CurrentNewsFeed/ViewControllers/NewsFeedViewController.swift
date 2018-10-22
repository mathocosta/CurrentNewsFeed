//
//  NewsFeedViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 17/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    var apiHandler = APIHandler()
    var loadedNews: [Item] = []
    var feedURLPath = ""
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var loadingMessageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        self.feedTableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsFeedCell")
        
        // Default settings for the loading message.
        self.loadingMessageLabel.text = "Carregando..."
        self.loadingMessageLabel.textAlignment = .center
        
        // First load.
        self.loadNews()
        
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.feedTableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let urlPath = UserDefaults.standard.string(forKey: "MainFeedURL"),
            urlPath != self.feedURLPath else { return }
        
        print("Appear", self.feedURLPath, urlPath)
        
        self.feedURLPath = urlPath
        self.loadedNews = []
        self.loadNews()
    }
    
    private func loadNews() {
        self.apiHandler.listOfStories(from: Endpoint(path: self.feedURLPath)) { (news) in
            DispatchQueue.main.async {
                self.loadedNews = news
                self.feedTableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayItemSegue" {
            guard let destination = segue.destination as? ItemViewController,
                let item = sender as? Item else { return }
            
            destination.item = item
            destination.hidesBottomBarWhenPushed = true
        }
    }

}

// MARK: - FeedTableView delegate and data source implementation.
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count " , self.loadedNews.count)
        let count = self.loadedNews.count
        self.feedTableView.backgroundView = count == 0 ? self.loadingMessageLabel : nil
    
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath) as? NewsFeedTableViewCell else {
            fatalError("The dequeued cell is not an instance of NewsFeedTableViewCell.")
        }
        
        let current = self.loadedNews[indexPath.row]
        cell.configureCell(item: current)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DisplayItemSegue", sender: self.loadedNews[indexPath.row])
    }
}

// MARK: - UIViewControllerPreviewingDelegate implementation.
extension NewsFeedViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.feedTableView.indexPathForRow(at: location),
            let cell = self.feedTableView.cellForRow(at: indexPath) else { return nil }
        
        guard let itemViewController = storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as? ItemViewController else { return nil }
        
        let item = self.loadedNews[indexPath.row]
        itemViewController.item = item
        itemViewController.preferredContentSize = CGSize(width: 0.0, height: 320)
        previewingContext.sourceRect = cell.frame
        
        return itemViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
