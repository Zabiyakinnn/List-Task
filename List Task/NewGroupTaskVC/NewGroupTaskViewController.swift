//
//  NewGroupTaskViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 01.11.2024.
//

import UIKit
import SnapKit

final class NewGroupTaskViewController: UIViewController, UITextViewDelegate {
    
    var nameGroup: NameGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        setupLoyout()
    }
    
//    поле ввода текста
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = UIColor(red: 0.93, green: 0.92, blue: 0.91, alpha: 1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //    заголовок
    private lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "New group task"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    кнопка сохранения
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "tray"), for: .normal)
        button.setTitle("Save", for: .normal)
        button.tintColor = UIColor(red: 0.32, green: 0.16, blue: 0.01, alpha: 1.00)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    сохранения группы для задач
    @objc private func saveButtonTapped() {
        if textView.hasText {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            if let nameGroup = nameGroup {
                nameGroup.name = textView.text
            } else {
                nameGroup = NameGroup(context: context)
                nameGroup?.name = textView.text
            }
            do {
                try context.save()
                dismiss(animated: true)
                print("Данные сохранены в Core Data \(String(describing: nameGroup))")
            } catch {
                print("Ошибка сохранения данных в Core Data: \(error)")
            }
        } else {
            print("Name group nil")
        }
    }
}

extension NewGroupTaskViewController {
    private func setupLoyout() {
        prepereView()
        setupConstraint()
        textView.delegate = self
        dismissKeyboard()
    }
    
    private func prepereView() {
        view.addSubview(labelHeadline)
        view.addSubview(saveButton)
        view.addSubview(textView)
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top).inset(30)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(20)
            make.right.equalTo(view.snp.right).inset(25)
            make.height.equalTo(40)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(58)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
            make.height.equalTo(100)
        }
    }
    
//    скрытие клавиатуры
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        textView.endEditing(true)
    }
}
