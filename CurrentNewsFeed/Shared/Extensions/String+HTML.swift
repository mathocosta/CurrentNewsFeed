//
//  String+HTML.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 24/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import Foundation

extension String {

    /// Returns a String from a HTML data string.
    ///
    /// - Returns: HTML processing result.
    func toAttributedString() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }

        do {
            let attrString = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil)
            return attrString
        } catch let error {
            print(error.localizedDescription)
            return NSAttributedString()
        }
    }
}
