//
//  TaskView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 29.11.2024.
//

import UIKit
import SnapKit

final class TaskView: UIView {
    
    //    MARK: - ContentView
    lazy var emptyView: UIView = {
       let emptyView = EmptyView()
        emptyView.isHidden = true
        return emptyView
    }()
    
    //    заголовок
    lazy var labelHeadline: UILabel = {
         let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont(name: "Bluecurve-Bold", size: 24)
        label.textAlignment = .left
        return label
    }()
    
    //    изображение
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //    кол-во задач
    lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Bluecurve-Light", size: 16)
        label.textColor = .lightGray
        return label
    }()
    
    //     tableCell
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.systemBackground
        tableView.separatorColor = .darkGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(TaskCell.self, forCellReuseIdentifier: "taskCell")
        return tableView
    }()
    
    //    MARK: - UIButton
    //    кнопка настройки списка
    lazy var settingsListButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = UIColor(named: "ButtonColorBlackAndWhite")
        return button
    }()
    
    //    кнопка закрытия ViewController
    lazy var closeVCButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "ButtonColorBlackAndWhite")
        return button
    }()
    
    //    новая задача
    lazy var newTaskButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let iconeImage = UIImage(systemName: "plus.circle")?.withTintColor(UIColor(named: "ButtonColorBlackAndWhite") ?? UIColor.lightGray, renderingMode: .alwaysOriginal)
        config.image = iconeImage
        config.imagePlacement = .top
        config.imagePadding = 6
        
        var title = AttributedString("Добавить новую задачу")
        title.foregroundColor = UIColor(named: "ColorTextBlackAndWhite")
        title.font = UIFont(name: "Bluecurve-Light", size: 20)
        config.attributedTitle = title
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.tintColor = .black
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHeader(name: String, taskCount: Int) {
        labelHeadline.text = name
        taskCountLabel.text = "Кол-во задач: \(taskCount)"
    }
}

//MARK: - SetupLoyout
extension TaskView {
    
    private func setupLoyout() {
        addSubview(labelHeadline)
        addSubview(iconImageView)
        addSubview(taskCountLabel)
        addSubview(tableView)
        addSubview(settingsListButton)
        addSubview(closeVCButton)
        addSubview(newTaskButton)
        addSubview(emptyView)
        setupConstraint()
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(72)
            make.left.equalToSuperview().inset(64)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(34)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(88)
            make.left.equalToSuperview().inset(25)
            make.height.width.equalTo(30)
        }
        settingsListButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(23)
            make.left.equalToSuperview().inset(30)
            make.height.width.equalTo(30)
        }
        closeVCButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(23)
            make.right.equalToSuperview().inset(30)
            make.height.width.equalTo(30)
        }
        taskCountLabel.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(43)
            make.left.equalToSuperview().inset(64)
        }
        newTaskButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(0)
            make.height.equalTo(90)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.top.equalTo(taskCountLabel.snp.top).inset(32)
            make.bottom.equalTo(newTaskButton.snp.bottom).inset(90)
        }
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }
    }
}
