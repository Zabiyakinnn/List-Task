//
//  NotificationUtils.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.11.2024.
//

import UIKit
import SnapKit

public final class NotificationUtils {
    
    static func showWarning(on viewController: UIViewController) {
        
        let notificationView = UIView()
        notificationView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        notificationView.layer.cornerRadius = 10
        
        let labelWarning = UILabel()
        labelWarning.text = "Заполните все поля"
        labelWarning.textColor = .white
        labelWarning.textAlignment = .center
        
        viewController.view.addSubview(notificationView)
        notificationView.addSubview(labelWarning)
        
        notificationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(viewController.view.safeAreaLayoutGuide.snp.top).offset(300)
        }
        labelWarning.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        notificationView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            notificationView.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5, animations: {
                notificationView.alpha = 0
            }) { _ in
                notificationView.removeFromSuperview()
            }
        }
    }
}

