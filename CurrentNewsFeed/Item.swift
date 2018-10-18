//
//  Item.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 18/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import Foundation

struct Item: Decodable {
    var author: String
    var published: Date
    var title: String
    var type: String
    var url: String
    
    private enum CodingKeys: String, CodingKey {
        case author = "by"
        case published = "time"
        case title
        case type
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.author = try container.decode(String.self, forKey: .author)
        let timeString = try container.decode(TimeInterval.self, forKey: .published)
        self.published = Date(timeIntervalSince1970: timeString)
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decode(String.self, forKey: .type)
        self.url = try container.decode(String.self, forKey: .url)
    }
}
