//
//  NewsFeedTableViewCell.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 17/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var urlText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleText.numberOfLines = 0
        self.titleText.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(item: Item) {
        self.titleText?.text = item.title
        
        let url = URL(string: item.url)
        self.urlText?.text = url?.host
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm | dd/MM/YY"
        self.dateText?.text = formatter.string(from: item.published)
    }
}
