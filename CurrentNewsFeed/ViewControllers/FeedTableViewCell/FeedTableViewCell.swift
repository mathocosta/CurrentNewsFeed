//
//  NewsFeedTableViewCell.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 17/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var subTitleText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryType = .disclosureIndicator
        
        self.titleText.numberOfLines = 0
        self.titleText.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(item: Item) {
        self.titleText?.text = item.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        self.subTitleText?.text = formatter.string(from: item.published)
        
        if let url = item.url, let host = URL(string: url)?.host {
            self.subTitleText?.text?.append(contentsOf: " | \(host)")
        }
    }
}
