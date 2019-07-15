//
//  ItemViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 19/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    // MARK: - Properties

    let itemView: ItemView

    var item: Item
    var cellIndexPath: IndexPath?
    var coordinator: Coordinator?
    var delegate: ItemViewControllerDelegate?

    var loadedComments: [Item] = []
    var apiHandler = APIHandler()
    
    lazy var previewActions: [UIPreviewActionItem] = {
        /// Action to save a favorite, this is done by getting the value of the item
        /// property that exists in the viewcontroller.
        let addFavoriteAction = UIPreviewAction(
            title: "Adicionar Favorito", style: .default, handler: { action, viewController in
                guard let vc = viewController as? ItemViewController else { return }
                
                self.save()
            }
        )
        return [addFavoriteAction]
    }()
    
    override var previewActionItems: [UIPreviewActionItem] {
        return self.previewActions
    }

    // MARK: - Lifecycle

    init(item: Item) {
        self.item = item
        self.itemView = ItemView(item: item)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.itemView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = self.itemView.rightBarButtom
        
        self.itemView.commentsTableView.delegate = self
        self.itemView.commentsTableView.dataSource = self

        // If the delegate is not nil, then it's because they come from the favorites screen.
        // FIXME: Not the best way to do this, but it will stay that way for now.
        if self.delegate != nil {
            self.itemView.rightBarButtom.title = "Remove"
            self.itemView.rightBarButtonTapped = self.remove
        } else {
            self.itemView.rightBarButtom.title = "Save"
            self.itemView.rightBarButtonTapped = self.save
        }
        
        if let kids = self.item.kids {
            self.apiHandler.items(from: kids) { items in
                DispatchQueue.main.async {
                    self.loadedComments = items
                    self.itemView.commentsTableView.reloadData()
                }
            }
        }
    }

    // MARK: - Methods

    private func remove() {
        self.delegate?.itemDeleted(self.item, at: self.cellIndexPath!)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func save() {
        let favorite = Favorite(context: DataManager.context)
        favorite.title = self.item.title
        favorite.type = self.item.type
        favorite.url = self.item.url
        favorite.published = self.item.published
        favorite.savedOn = Date()
        
        DataManager.saveContext()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ItemViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.loadedComments.count
        tableView.backgroundView = count == 0 ? self.itemView.loadingMessageLabel : nil
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CommentItemCell", for: indexPath) as? CommentItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of CommentItemTableViewCell.")
        }
        
        let current = self.loadedComments[indexPath.row]
        cell.configureCell(item: current)
        
        return cell
    }
    
}
