//
//  ItemView.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 13/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import UIKit

final class ItemView: UIView {

    // MARK: - Properties
    let authorText: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let titleText: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let commentsTableViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Comments"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let loadingMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading Comments..."
        label.textAlignment = .center

        return label
    }()

    let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            UINib(nibName: "CommentItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentItemCell")

        return tableView
    }()

    let rightBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.style = .plain
        button.possibleTitles = ["Save", "Delete"]

        return button
    }()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm"

        return formatter
    }()

    // MARK: - Lifecycle
    init(item: Item, frame: CGRect = .zero) {
        self.authorText.text = "by \(item.author ?? ""), at \(self.dateFormatter.string(from: item.published))"
        self.titleText.text = item.title
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    var rightBarButtonTapped: (() -> Void)?

    @objc func onRightButton(_ sender: UIBarButtonItem) {
        guard let rightBarButtonTapped = self.rightBarButtonTapped else { return }

        rightBarButtonTapped()
    }

}

// MARK: - CodeView
extension ItemView: CodeView {

    func buildViewHierarchy() {
        self.addSubview(self.authorText)
        self.addSubview(self.titleText)
        self.addSubview(self.commentsTableViewLabel)
        self.addSubview(self.commentsTableView)
    }

    func setupConstraints() {
        self.authorText.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.authorText.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.authorText.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true

        self.titleText.topAnchor.constraint(equalTo: self.authorText.bottomAnchor, constant: 8).isActive = true
        self.titleText.leadingAnchor.constraint(equalTo: self.authorText.leadingAnchor).isActive = true
        self.titleText.trailingAnchor.constraint(equalTo: self.authorText.trailingAnchor).isActive = true

        self.commentsTableViewLabel.topAnchor.constraint(equalTo: self.titleText.bottomAnchor, constant: 30).isActive = true
        self.commentsTableViewLabel.leadingAnchor.constraint(equalTo: self.authorText.leadingAnchor).isActive = true
        self.commentsTableViewLabel.trailingAnchor.constraint(equalTo: self.authorText.trailingAnchor).isActive = true

        self.commentsTableView.topAnchor.constraint(equalTo: self.commentsTableViewLabel.bottomAnchor, constant: 10).isActive = true
        self.commentsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.commentsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.commentsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
        self.rightBarButton.target = self
        self.rightBarButton.action = #selector(onRightButton(_:))
    }

}
