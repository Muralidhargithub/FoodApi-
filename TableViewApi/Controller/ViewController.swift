//
//  ViewController.swift
//  TableViewApi
//
//  Created by Muralidhar reddy Kakanuru on 12/1/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    let tableView = CustomTableView()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - UI Setup
    func setUI(){
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }


}

