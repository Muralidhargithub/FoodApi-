//
//  ViewController.swift
//  TableViewApi
//
//  Created by Muralidhar reddy Kakanuru on 12/1/24.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    let tableView = CustomFoodTableView()
    var gitData: GitData?
    {
        didSet {
            tableView.gitData = gitData
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setUI() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

