//
//  PlaceholderCell.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 02.11.2024.
//

import UIKit
import SnapKit

final class PlaceholderCell: UICollectionViewCell {
    
    //    имя задачи
    private lazy var nameTask: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "Создайте группу для своих задач"
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupeLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        nameTask.text = text
    }
}

//MARK: - PlaceholderCell Methods
extension PlaceholderCell {
    private func setupeLoyout() {
        prepereView()
        setupeConstraint()
    }
    private func prepereView() {
        contentView.addSubview(nameTask)
    }
    private func setupeConstraint() {
        nameTask.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
