//
//  Item.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 18/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import Foundation

struct Item: Decodable {
    var id: Int
    var author: String?
    var published: Date
    var type: String
    
    var title: String?
    var body: String?
    var kids: [Int]?
    var url: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case author = "by"
        case published = "time"
        case type
        case title
        case body = "text"
        case kids
        case url
    }
    
    /// Init from Favorite NSManagedObject, it is used to
    /// build the table view cell on favorites view controller.
    ///
    /// - Parameter favorite: Favorite NSManagedObject
    init(from favorite: Favorite) {
        self.id = Int(favorite.itemID)
        self.author = favorite.author ?? ""
        self.published = favorite.published ?? Date()
        self.title = favorite.title ?? ""
        self.type = favorite.type ?? ""
        self.url = favorite.url ?? ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let timeString = try container.decode(TimeInterval.self, forKey: .published)
        self.published = Date(timeIntervalSince1970: timeString)
        self.type = try container.decode(String.self, forKey: .type)
        self.id = try container.decode(Int.self, forKey: .id)

        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
        self.kids = try container.decodeIfPresent([Int].self, forKey: .kids)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
    }
}
