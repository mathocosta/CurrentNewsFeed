//
//  ItemViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 19/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    @IBOutlet weak var authorText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var loadingMessageLabel = UILabel()
    
    var loadedComments: [Item] = []
    var apiHandler = APIHandler()
    
    var item: Item?
    var previousController: UIViewController?
    
    lazy var previewActions: [UIPreviewActionItem] = {
        /// Action to save a favorite, this is done by getting the value of the item
        /// property that exists in the viewcontroller.
        let addFavoriteAction = UIPreviewAction(
            title: "Adicionar Favorito", style: .default, handler: { action, viewController in
                guard let vc = viewController as? ItemViewController,
                    let item = vc.item else { return }
                
                self.save(favorite: item)
            }
        )
        return [addFavoriteAction]
    }()
    
    override var previewActionItems: [UIPreviewActionItem] {
        return previewActions
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.loadingMessageLabel.text = "Loading Comments..."
        self.loadingMessageLabel.textAlignment = .center
        
        self.commentsTableView.delegate = self
        self.commentsTableView.dataSource = self
        self.commentsTableView.register(UINib(nibName: "CommentItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentItemCell")
        
        if self.previousController is FavoritesFeedViewController {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        if let item = item {
            self.configureView(item: item)
        }
        
        if let kids = self.item?.kids {
            self.apiHandler.items(from: kids) { items in
                DispatchQueue.main.async {
                    self.loadedComments = items
                    self.commentsTableView.reloadData()
                }
            }
        }
    }
    
    /// Configure view with the data passed via paramenter.
    ///
    /// - Parameter item: Item object with the data to be used.
    func configureView(item: Item) {
        self.titleText?.text = item.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm"
        
        if let author = item.author {
            self.authorText?.text = "by \(author), at \(formatter.string(from: item.published))"
        }
    }

    @IBAction func saveFavoriteAction(_ sender: UIBarButtonItem) {
        guard let item = self.item else { return }
        
        self.save(favorite: item)
    }
    
    private func save(favorite item: Item) {
        let favorite = Favorite(context: DataManager.context)
        favorite.title = item.title
        favorite.type = item.type
        favorite.url = item.url
        favorite.published = item.published
        favorite.savedOn = Date()
        
        DataManager.saveContext()
    }
}

extension ItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.loadedComments.count
        self.commentsTableView.backgroundView = count == 0 ? self.loadingMessageLabel : nil
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItemCell", for: indexPath) as? CommentItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of CommentItemTableViewCell.")
        }
        
        let current = self.loadedComments[indexPath.row]
        cell.configureCell(item: current)
        
        return cell
    }
}
