//
//  CommentItemTableViewCell.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 23/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

class CommentItemTableViewCell: UITableViewCell {
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var bodyText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(item: Item) {
        guard let author = item.author, let body = item.body else { return }
        
        self.headerText.text = author
        self.bodyText.text = body
    }
}
