//
//  SettingsViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 22/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var availableFeedsOptions: [String] {
        return APIEndpoints.allCases.map { "\($0.info.label)" }
    }
    
    @IBOutlet weak var availableFeedsPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.availableFeedsPicker.delegate = self
        self.availableFeedsPicker.dataSource = self
        
        let selected = UserDefaults.standard.integer(forKey: "MainFeedURL")
        self.availableFeedsPicker.selectRow(selected, inComponent: 0, animated: false)
    }

}

// MARK: - AvailableFeedsPicker delegate and data source implementation.
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return APIEndpoints.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return APIEndpoints(rawValue: row)?.info.label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Save the setting to be used when requesting main page content.
        UserDefaults.standard.set(row, forKey: "MainFeedURL")
    }
}
