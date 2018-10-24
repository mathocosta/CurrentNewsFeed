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
        
        self.selectionStyle = .none
        
        self.bodyText.isScrollEnabled = false
        self.bodyText.isEditable = false
        // Remove padding.
        self.bodyText.textContainerInset = UIEdgeInsets.zero
        self.bodyText.textContainer.lineFragmentPadding = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(item: Item) {
        guard let author = item.author, let body = item.body else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let published = formatter.string(from: item.published)
        
        self.headerText.text = "by \(author), at \(published)"
        self.bodyText.text = body.toAttributedString().string
    }
}
