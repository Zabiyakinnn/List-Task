//
//  PriorityView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 23.12.2024.
//

import UIKit
import SnapKit

final class PriorityView: UIView {
    
    private let animationDuration = 0.3
    let priorityViewCell = "priorityViewCell"
    
    private let priority = ["Нет", "Низкий", "Средний", "Высокий"]
    private let priorityColors: [UIColor] = [
        .lightGray, // "Нет"
        .systemGreen, // "Низкий"
        .systemOrange, // "Средний"
        .systemRed // "Высокий"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstrain()
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - View
    //    заголовок
    private lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.text = "Приоритет"
        label.textAlignment = .center
        return label
    }()
    
//    tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorColor = .darkGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PriorityViewCell.self, forCellReuseIdentifier: "priorityViewCell")
        return tableView
    }()
    
    //    MARK: - Анимация открытия
        func show(in parentView: UIView) {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / 2)
            parentView.addSubview(self)
            
            self.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(380)
                make.bottom.equalToSuperview()
            }
            
            UIView.animate(withDuration: animationDuration, animations: {
                self.alpha = 1
                self.transform = .identity
            })
        }
        
    //    MARK: - Анимация закрытия
        func hide(completion: (() -> Void)? = nil) {
            UIView.animate(withDuration: animationDuration, animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / 2)
            }) { _ in
                self.removeFromSuperview()
                completion?()
            }
        }
}

//MARK: - SetupView
extension PriorityView {
    private func setupView() {
        addSubview(labelHeadline)
        addSubview(tableView)
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    private func setupConstrain() {
        labelHeadline.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(23)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.top.equalTo(labelHeadline.snp.top).inset(35)
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension PriorityView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priority.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: priorityViewCell, for: indexPath) as? PriorityViewCell
        
        let priority = priority[indexPath.row]
        let priorityColor = priorityColors[indexPath.row]
        
        cell?.priorityLabel.text = priority
        cell?.iconPriority.tintColor = priorityColor

        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
 
}
