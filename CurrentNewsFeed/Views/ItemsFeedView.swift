//
//  ItemsFeedView.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 13/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import UIKit

class ItemsFeedView: UIView {

    let loadingMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading Stories..."
        label.textAlignment = .center

        return label
    }()

    let feedTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsFeedCell")

        return tableView
    }()

    // MARK: - Initializers
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - CodeView
extension ItemsFeedView: CodeView {

    func buildViewHierarchy() {
        self.addSubview(self.feedTableView)
    }

    func setupConstraints() {
        self.feedTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        self.feedTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.feedTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.feedTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {

    }

}
