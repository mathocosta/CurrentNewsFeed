//
//  SettingsViewController.swift
//  CurrentNewsFeed
//
//  Created by Matheus Costa on 22/10/18.
//  Copyright © 2018 Matheus Costa. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    let availableFeedsOptions = [
        (label: "Top Stories", urlPath: "/v0/topstories.json"),
        (label: "Show Stories", urlPath: "/v0/showstories.json")
    ]
    
    @IBOutlet weak var availableFeedsPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.availableFeedsPicker.delegate = self
        self.availableFeedsPicker.dataSource = self
    }

}

// MARK: - AvailableFeedsPicker delegate and data source implementation.
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.availableFeedsOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.availableFeedsOptions[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Save the setting to be used when requesting main page content.
    }
}
