//
//  NewTaskCell.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.11.2024.
//

import UIKit
import SnapKit

class NewTaskCell: UITableViewCell {
    
//    MARK: - View
    
    private lazy var nameTask: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameTask)
        
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewTaskCell {
    private func setupConstraint() {
        nameTask.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(7)
            make.left.equalTo(contentView.snp.left).inset(10)
        }
    }
}
