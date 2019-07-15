//
//  SettingsView.swift
//  CurrentNewsFeed
//
//  Created by Matheus Oliveira Costa on 11/07/19.
//  Copyright © 2019 Matheus Costa. All rights reserved.
//

import UIKit

final class SettingsView: UIView {

    // MARK: - Subviews
    let defaultFeedLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Feed"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let defaultFeedPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.showsSelectionIndicator = true
        
        return picker
    }()
    
    let defaultFeedPickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done", style: .plain, target: self, action: #selector(toolbarOnDone(_:)))
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(
            title: "Cancel", style: .plain, target: self, action: #selector(toolbarOnCancel(_:)))
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    let defaultFeedField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    /// Handler to be called when the default feed setting change
    var defaultFeedShouldChange: (() -> Void)?
    
    @objc func toolbarOnDone(_ sender: UIButton) {
        guard let defaultFeedShouldChange = self.defaultFeedShouldChange else { return }
        
        defaultFeedShouldChange()
        
        self.defaultFeedField.resignFirstResponder()
    }
    
    @objc func toolbarOnCancel(_ sender: UIButton) {
        self.defaultFeedField.resignFirstResponder()
    }
    
}

// MARK: - CodeView
extension SettingsView: CodeView {
    
    func buildViewHierarchy() {
        self.addSubview(self.defaultFeedLabel)
        
        self.defaultFeedField.inputView = self.defaultFeedPicker
        self.defaultFeedField.inputAccessoryView = self.defaultFeedPickerToolbar
        self.addSubview(self.defaultFeedField)
    }
    
    func setupConstraints() {
        self.defaultFeedLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.defaultFeedLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.defaultFeedLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        self.defaultFeedField.topAnchor.constraint(equalTo: self.defaultFeedLabel.bottomAnchor, constant: 8).isActive = true
        self.defaultFeedField.trailingAnchor.constraint(equalTo: self.defaultFeedLabel.trailingAnchor).isActive = true
        self.defaultFeedField.leadingAnchor.constraint(equalTo: self.defaultFeedLabel.leadingAnchor).isActive = true
    }
    
    func setupAdditionalConfiguration() {
    }
    
}
