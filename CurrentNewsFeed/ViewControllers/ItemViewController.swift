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
    @IBOutlet weak var urlText: UILabel!
    
    var item: Item?
    
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
        
        if let item = item {
            self.configureView(item: item)
        }
    }
    
    /// Configure view with the data passed via paramenter.
    ///
    /// - Parameter item: Item object with the data to be used.
    func configureView(item: Item) {
        self.titleText?.text = item.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm"
        self.authorText?.text = "by \(item.author) at \(formatter.string(from: item.published))"
        
        let url = URL(string: item.url)
        self.urlText?.text = url?.host
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
