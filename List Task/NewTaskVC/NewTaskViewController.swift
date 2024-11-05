//
//  NewTaskViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.11.2024.
//

import UIKit
import SnapKit

final class NewTaskViewController: UIViewController {
    
    var nameGroup: NameGroup?
    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoyout()
        view.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    MARK: - ContentView
//    заголовок
    private lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.text = nameGroup?.name
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    изображение
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        if let iconData = nameGroup?.iconNameGroup,
           let iconImage = UIImage(data: iconData)?.withRenderingMode(.alwaysTemplate) {
            imageView.image = iconImage
            imageView.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
//    кол-во задач
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "Кол-во задач: 0"
        label.textColor = .darkGray
        return label
    }()
    
//    MARK: - UIButton
//    кнопка настройки списка
    private lazy var settingsListButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.addTarget(self, action: #selector(settingsListButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func settingsListButtonTapped() {
        print("Tapped settingsListButtonTapped")
    }
    
    //    кнопка закрытия ViewController
    private lazy var closeVCButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.addTarget(self, action: #selector(closeVCButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func closeVCButtonTapped() {
        dismiss(animated: true)
    }
    
    //    новая задача
    private lazy var newTaskButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let iconeImage = UIImage(systemName: "plus.circle")?.withTintColor(UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00), renderingMode: .alwaysOriginal)
        config.image = iconeImage
        config.imagePlacement = .top
        config.imagePadding = 6
        
        var title = AttributedString("Добавить новую задачу")
        title.foregroundColor = .black
        config.attributedTitle = title
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
}

//MARK: - Method
extension NewTaskViewController {
    private func setupLoyout() {
        prepereView()
        setupConstraint()
    }
    
    private func prepereView() {
        view.addSubview(labelHeadline)
        view.addSubview(iconImageView)
        view.addSubview(settingsListButton)
        view.addSubview(closeVCButton)
        view.addSubview(taskCountLabel)
        view.addSubview(newTaskButton)
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(72)
            make.left.equalTo(view.snp.left).inset(70)
            make.height.equalTo(34)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(76)
            make.left.equalTo(view.snp.left).inset(30)
            make.height.width.equalTo(30)
        }
        settingsListButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(23)
            make.left.equalTo(view.snp.left).inset(30)
            make.height.width.equalTo(30)
        }
        closeVCButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(23)
            make.right.equalTo(view.snp.right).inset(30)
            make.height.width.equalTo(30)
        }
        taskCountLabel.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(43)
            make.left.equalTo(view.snp.left).inset(70)
        }
        newTaskButton.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(0)
            make.bottom.equalTo(view.snp.bottom).inset(0)
            make.height.equalTo(90)
        }
    }
}
