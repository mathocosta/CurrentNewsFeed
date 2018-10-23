//
//  APIHandler.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 16/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

enum APIEndpoints: Int, CaseIterable {
    case topstories
    case askstories
    case beststories
    case showstories
    
    var info: (label: String, endpoint: Endpoint) {
        switch self {
        case .topstories:
            return ("Top Stories", Endpoint(path: "/v0/topstories.json"))
        case .askstories:
            return ("Ask Stories", Endpoint(path: "/v0/askstories.json"))
        case .beststories:
            return ("Best Stories", Endpoint(path: "/v0/beststories.json"))
        case .showstories:
            return ("Show Stories", Endpoint(path: "/v0/showstories.json"))
        }
    }
}

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

class APIHandler: NSObject {
    
    /// Fetch all stories on hacker news front page, based on endpoint passed by argument.
    ///
    /// - Parameter completion: Action for when the request is finished.
    func listOfStories(from endpoint: Endpoint, then completion: @escaping ([Item]) -> Void) {
        var storiesItems = [Item]()
        
        self.request(endpoint) { resultData in
            do {
                var storiesIds = try JSONDecoder().decode([Int].self, from: resultData)
                storiesIds = Array(storiesIds[0..<15])
                
                // TODO: Refactor this code below to use the new method `items(from:then:)`.
                let dispatchQueue = DispatchQueue(label: "individualItemQueue", qos: .userInitiated)
                let dispatchGroup = DispatchGroup.init()
                
                for id in storiesIds {
                    dispatchGroup.enter()
                    self.individualItem(for: id, then: { item in
                        storiesItems.append(item)
                        dispatchGroup.leave()
                    })
                }
                
                dispatchGroup.notify(queue: dispatchQueue, execute: {
                    completion(storiesItems)
                })
            } catch let parsingError {
                print("Parsing error of top stories: ", parsingError.localizedDescription)
            }
        }
    }
    
    /// Gets the objects of items based on a list of ids.
    ///
    /// - Parameters:
    ///   - itemList: List of identifiers
    ///   - completion: Action for when the request is finished.
    func items(from itemList: [Int], then completion: @escaping ([Item]) -> Void) {
        var items = [Item]()
        
        let dispatchQueue = DispatchQueue(label: "individualItemQueue", qos: .userInitiated)
        let dispatchGroup = DispatchGroup.init()
        
        for id in itemList {
            dispatchGroup.enter()
            self.individualItem(for: id) { item in
                items.append(item)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: dispatchQueue, execute: {
            completion(items)
        })
    }
    
    /// Fetch for an individual item by id.
    ///
    /// - Parameters:
    ///   - id: Indetifier of item in API.
    ///   - completion: Action for when the request is finished.
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
    
    
    /// Makes a request based on the received endpoint, then run the completion clousure.
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint for the request.
    ///   - completion: Action to be performed when the request is finished, with the data received.
    private func request(_ endpoint: Endpoint, then completion: @escaping (Data) -> Void) {
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
