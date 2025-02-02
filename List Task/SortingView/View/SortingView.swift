//
//  SortingView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 18.01.2025.
//

import UIKit
import SnapKit

final class SortingView: UIView {
    
    let sorting = ["По имени", "По дате", "По приоритету"] // выбор сортировки задач 

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    title экрана
    private lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.text = "Выбор сортировки"
        label.textAlignment = .center
        return label
    }()
    
//    tableView sorting
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorColor = .darkGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .darkGray
        tableView.register(SortingViewCell.self, forCellReuseIdentifier: "sotringViewCell")
        return tableView
    }()
    
//    кнопка закрыть экран
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "ButtonColorBlackAndWhite")
        return button
    }()
}

// MARK: - SetupLoyout
extension SortingView {
    private func setupLoyout() {
        addSubview(labelHeadline)
        addSubview(tableView)
        addSubview(closeButton)
        
        setupConsntraint()
    }
    
    private func setupConsntraint() {
        labelHeadline.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(30)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.top.equalTo(labelHeadline.snp.top).inset(35)
            make.bottom.equalToSuperview()
        }
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(labelHeadline)
            make.right.equalToSuperview().offset(-24)
            make.height.width.equalTo(30)
        }
    }
}
