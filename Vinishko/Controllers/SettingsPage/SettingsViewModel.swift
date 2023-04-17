//
//  SettingsViewModel.swift
//  Vinishko
//
//  Created by mttm on 06.02.2023.
//

import UIKit

struct SettingsOption {
    var name: String
    var id: Int
}

struct SettingsSection {
    var name: String
}

protocol SettingsViewModelDelegate: AnyObject {
    func dataDidUpdate()
}

class SettingsViewModel: NSObject {
    
    weak var delegate: SettingsViewModelDelegate?
    private let settingsOptions = [SettingsOption(name: LocalizableText.shareImageText, id: 0),
                                   SettingsOption(name: LocalizableText.shareCommentText, id: 1),
                                   SettingsOption(name: LocalizableText.shareRatingText, id: 2)]
    
    init(delegate: SettingsViewModelDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    func checkSwitchStatus(by id: Int) -> Bool {
        var result: Bool!
        switch id {
        case 0:
            result = userDefaults.bool(forKey: "shareImage")
        case 1:
            result = userDefaults.bool(forKey: "shareComment")
        case 2:
            result = userDefaults.bool(forKey: "shareRating")
        default:
            break
        }
        return result
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource

extension SettingsViewModel: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return LocalizableText.sectionQRText
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! SettingsCell
        cell.settingsOptionLabel.text = settingsOptions[indexPath.row].name
        cell.settingsSwitch.tag = settingsOptions[indexPath.row].id
        cell.settingsSwitch.setOn(checkSwitchStatus(by: settingsOptions[indexPath.row].id), animated: true)
        cell.settingsSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        return cell
    }
    
    @objc private func switchChanged(_ sender: UISwitch!) {
        switch sender.tag {
        case 0:
            userDefaults.set(sender.isOn, forKey: "shareImage")
        case 1:
            userDefaults.set(sender.isOn, forKey: "shareComment")
        case 2:
            userDefaults.set(sender.isOn, forKey: "shareRating")
        default:
            break
        }
    }
}
