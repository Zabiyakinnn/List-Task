//
//  MoreColorView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 22.03.2025.
//

import UIKit
import SnapKit

final class MoreColorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Content
    //    заголовок
    lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont(name: "Bluecurve-Light", size: 20)
        label.text = "Цвета"
        label.textAlignment = .center
        return label
    }()
    
    //    кнопка закрыть viewController
    lazy var closeVCButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "ButtonColorBlackAndWhite")
        return button
    }()
}

//MARK: - SetupLoyout
extension MoreColorView {
    private func setupLoyout() {
        addSubview(labelHeadline)
        addSubview(closeVCButton)
        setupConstraint()
    }
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeVCButton)
        }
        closeVCButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(23)
            make.right.equalToSuperview().inset(30)
            make.height.width.equalTo(30)
        }
    }
}
