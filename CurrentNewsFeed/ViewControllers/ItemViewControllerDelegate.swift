//
//  ItemViewControllerDelegate.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 24/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import Foundation

protocol ItemViewControllerDelegate {
    func itemDeleted(_ item: Item, at position: IndexPath)
}
