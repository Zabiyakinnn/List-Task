//
//  PriorityViewCell.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 23.12.2024.
//

import UIKit
import SnapKit

final class PriorityViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - View
    //    тип приоритета
    lazy var priorityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "Bluecurve-Light", size: 17)
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        return label
    }()
    
//    иконка приоритета
    lazy var iconPriority: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "app")?.withRenderingMode(.alwaysTemplate)
        return imageView
    }()
    
//    галочка выбранной ячейки с приоритетом
    lazy var checkmarkImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemGreen
        return imageView
    }()
}

//MARK: - SetupLoyout
extension PriorityViewCell {
    private func setupLoyout() {
        prepereView()
        setupConstraint()
    }
    
    private func prepereView() {
        addSubview(priorityLabel)
        addSubview(iconPriority)
        addSubview(checkmarkImageView)
    }
    
    private func setupConstraint() {
        priorityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconPriority.snp.left).inset(30)
        }
        iconPriority.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(contentView.snp.left).inset(25)
        }
        checkmarkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(contentView.snp.right).offset(-25)
        }
    }
}
