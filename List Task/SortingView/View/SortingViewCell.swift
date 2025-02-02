//
//  SortingViewCell.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 18.01.2025.
//

import UIKit
import SnapKit

final class SortingViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - View
//    тип сортировки
    lazy var sortingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        return label
    }()
    
    //    галочка выбранного типа сортировки
    lazy var checkmarkSorting: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemGreen
        return imageView
    }()
}

//MARK: - SetupLoyout
extension SortingViewCell {
    private func setupLoyout() {
        prepereView()
        setupConstraint()
    }
    
    private func prepereView() {
        addSubview(sortingLabel)
        addSubview(checkmarkSorting)
    }
    
    private func setupConstraint() {
        sortingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(contentView.snp.left).inset(30)
        }
        checkmarkSorting.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(contentView.snp.right).offset(-25)
        }
    }
}
