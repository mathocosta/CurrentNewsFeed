//
//  APIHandler.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 16/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

struct Endpoint {
    let path: String
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "hacker-news.firebaseio.com"
        components.path = self.path
        
        return components.url
    }
}

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

class APIHandler: NSObject {
    
    func topStories(then completion: @escaping ([Item]) -> Void) {
        self.request(Endpoint(path: "/v0/topstories.json")) { resultData in
            do {
                var storiesIds = try JSONDecoder().decode([Int].self, from: resultData)
                storiesIds = Array(storiesIds[0...10])
                
                var storiesItems = [Item]()
                
                for id in storiesIds {
                    self.individualItem(for: id, then: { item in
                        storiesItems.append(item)
                    })
                }
                
                completion(storiesItems)
                
            } catch let parsingError {
                print("Parsing error of top stories: ", parsingError)
            }
        }
    }
    
    func individualItem(for id: Int, then completion: @escaping (Item) -> Void) {
        self.request(Endpoint(path: "/v0/item/\(id).json")) { data in
            do {
                let item = try JSONDecoder().decode(Item.self, from: data)
                
                completion(item)
            } catch let parsingError {
                print("Parsing error in individual item: ", parsingError)
            }
        }
    }
    
    func request(_ endpoint: Endpoint, then completion: @escaping (Data) -> Void) {
        guard let url = endpoint.url else {
            print("Error on url")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let validData = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            
            completion(validData)
        }
        
        DispatchQueue.global(qos: .background).async {
            task.resume()
        }
    }
}
