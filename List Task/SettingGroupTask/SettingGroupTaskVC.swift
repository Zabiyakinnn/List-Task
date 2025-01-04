//
//  SettingGroupTaskVC.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.01.2025.
//

import UIKit

final class SettingGroupTaskVC: UIViewController {
    
    private var settingGroupTaskView = SettingGroupTaskView()
    
//    MARK: - LoadView
    override func loadView() {
        self.view = settingGroupTaskView
    }
    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
