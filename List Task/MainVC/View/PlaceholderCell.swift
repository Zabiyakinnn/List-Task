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
        configureUI()
    }
    
    private func prepereView() {
        contentView.addSubview(nameTask)
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(red: 0.93, green: 0.92, blue: 0.91, alpha: 1.00)
        contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }

    private func setupeConstraint() {
        nameTask.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
