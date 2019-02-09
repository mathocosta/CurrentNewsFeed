//
//  FavoritesFeedViewModelDelegate.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 09/02/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import Foundation

protocol FavoritesViewModelDelegate: class {
    func favoriteRemoved(_ favorite: Favorite, at indexPath: IndexPath)
}
