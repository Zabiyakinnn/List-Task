//
//  EmptyCell.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 05.12.2024.
//

import UIKit
import SnapKit

class EmptyView: UIView {
    
//заголовок
    lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.text = "Список задач пуст"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SetupLoyout
extension EmptyView {
    
    private func setupLoyout() {
        backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        
        addSubview(labelHeadline)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}
