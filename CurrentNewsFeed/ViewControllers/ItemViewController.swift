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
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    var loadingMessageLabel = UILabel()
    
    var itemViewModel: ItemViewModel!
    var cellIndexPath: IndexPath?
    var delegate: ItemViewControllerDelegate?
    
    lazy var previewActions: [UIPreviewActionItem] = {
        /// Action to save a favorite, this is done by getting the value of the item
        /// property that exists in the viewcontroller.
        let addFavoriteAction = UIPreviewAction(
            title: "Adicionar Favorito", style: .default, handler: { _, _ in
                self.itemViewModel.saveAsFavorite()
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
        
        // If the delegate is not nil, then it's because they come from the favorites screen.
        // FIXME: Not the best way to do this, but it will stay that way for now.
        if self.delegate != nil {
            self.rightButton.title = "Remove"
        } else {
            self.rightButton.title = "Save"
        }
        
        self.titleText.text = self.itemViewModel.titleText
        self.authorText.text = self.itemViewModel.subtitleText
        
        if self.itemViewModel.hasKids {
            self.itemViewModel.fetchKids { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.commentsTableView.reloadData()
                    }
                }
            }
        }
    }

    @IBAction func rightButtonAction(_ sender: UIBarButtonItem) {
        // FIXME: Again, not the best way to do this, but it will stay that way for now.
        if self.delegate == nil {
            self.itemViewModel.saveAsFavorite()
        } else {
            self.delegate?.itemDeleted(self.itemViewModel, at: self.cellIndexPath!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension ItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.itemViewModel.fetchedKids.count
        self.commentsTableView.backgroundView = count == 0 ? self.loadingMessageLabel : nil
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItemCell", for: indexPath) as? CommentItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of CommentItemTableViewCell.")
        }
        
        let current = self.itemViewModel.fetchedKids[indexPath.row]
        cell.configureCell(item: current)
        
        return cell
    }
    
}
