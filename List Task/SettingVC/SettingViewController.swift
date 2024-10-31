//
//  SettingViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 31.10.2024.
//

import UIKit

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
    }
}
