//
//  MoreColorViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 22.03.2025.
//

import UIKit

final class MoreColorViewController: UIViewController {
    
    private var moreColorView = MoreColorView()
    
//    MARK: loadView
    override func loadView() {
        self.view = moreColorView
    }
    
//    MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
    
//    MARK: setupButton
    private func setupButton() {
        moreColorView.closeVCButton.addTarget(self, action: #selector(closeVCButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeVCButtonTapped() {
        dismiss(animated: true)
    }
    
}
