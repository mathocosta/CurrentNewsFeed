//
//  SettingsViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 22/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var feedChoices: [(label: String, endpoint: Endpoint)] {
        return APIEndpoints.allCases.map { $0.info }
    }
    
    var selectedChoice: Int?
    
    @IBOutlet weak var defaultFeedField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureFeedChoicesField()
    }
    
    // TODO: create a separate controller for that texfield and pickerview configuration part.
    func configureFeedChoicesField() {
        let defaultFeedPicker = UIPickerView()
        
        defaultFeedPicker.delegate = self
        defaultFeedPicker.dataSource = self
        defaultFeedPicker.showsSelectionIndicator = true
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneAction))
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(
            title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelAction))
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        let selected = UserDefaults.standard.integer(forKey: "MainFeedURL")
        defaultFeedPicker.selectRow(selected, inComponent: 0, animated: false)
        
        self.defaultFeedField.text = APIEndpoints(rawValue: selected)?.info.label
        self.defaultFeedField.inputView = defaultFeedPicker
        self.defaultFeedField.inputAccessoryView = toolbar
    }
    
    @objc func doneAction(sender: UIButton) {
        // Save the setting to be used when requesting main page content.
        UserDefaults.standard.set(self.selectedChoice, forKey: "MainFeedURL")
        
        let label = APIEndpoints(rawValue: self.selectedChoice!)?.info.label
        self.defaultFeedField.text = label
        
        self.defaultFeedField.resignFirstResponder()
    }
    
    @objc func cancelAction(sender: UIButton) {
        self.defaultFeedField.resignFirstResponder()
    }
}

// MARK: - AvailableFeedsPicker delegate and data source implementation.
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.feedChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.feedChoices[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedChoice = row
    }
}
