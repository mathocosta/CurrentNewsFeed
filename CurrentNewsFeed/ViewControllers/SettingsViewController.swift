//
//  SettingsViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 22/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    var coordinator: SettingsCoordinator?
    
    var feedChoices: [(label: String, endpoint: Endpoint)] {
        return APIEndpoints.allCases.map { $0.info }
    }
    
    var selectedChoice: Int?
    
    override func loadView() {
        self.view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Settings"

        if let settingsView = self.view as? SettingsView {
            settingsView.defaultFeedPicker.delegate = self
            settingsView.defaultFeedPicker.dataSource = self
            
            let userDefaults = UserDefaults.standard
            
            let selectedFeedSaved = userDefaults.integer(forKey: "MainFeedURL")
            settingsView.defaultFeedPicker.selectRow(selectedFeedSaved, inComponent: 0, animated: false)
            settingsView.defaultFeedField.text = APIEndpoints(rawValue: selectedFeedSaved)?.info.label
            
            settingsView.defaultFeedShouldChange = { [weak self] in
                guard let newFeedSelected = self?.selectedChoice else { return }
                
                // Save the setting to be used when requesting main page content.
                userDefaults.set(newFeedSelected, forKey: "MainFeedURL")
                
                let label = APIEndpoints(rawValue: newFeedSelected)?.info.label
                settingsView.defaultFeedField.text = label
            }
        }
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
