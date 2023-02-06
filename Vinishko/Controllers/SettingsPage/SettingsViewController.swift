//
//  SettingsViewController.swift
//  Vinishko
//
//  Created by mttm on 06.02.2023.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: SettingsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewModel(delegate: self)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func dataDidUpdate() {}
}
