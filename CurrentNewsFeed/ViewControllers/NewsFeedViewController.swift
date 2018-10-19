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
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        self.feedTableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsFeedCell")
        
        self.apiHandler.topStories { (news) in
            DispatchQueue.main.async {
                self.loadedNews = news
                self.feedTableView.reloadData()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// - MARK: FeedTableView delegate and data source implementation.
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count " , self.loadedNews.count)
        return self.loadedNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath) as? NewsFeedTableViewCell else {
            fatalError("The dequeued cell is not an instance of NewsFeedTableViewCell.")
        }
        
        let current = self.loadedNews[indexPath.row]
        cell.configureCell(item: current)
        
        return cell
    }
}
