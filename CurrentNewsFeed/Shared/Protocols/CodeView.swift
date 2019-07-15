//
//  CodeView.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 11/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import Foundation

protocol CodeView {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}

extension CodeView {
    
    func setupView() {
        self.buildViewHierarchy()
        self.setupConstraints()
        self.setupAdditionalConfiguration()
    }
    
}
