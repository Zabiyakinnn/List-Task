//
//  NewGroupTaskViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 01.11.2024.
//

import UIKit
import SnapKit

final class NewGroupTaskViewController: UIViewController, UITextViewDelegate {
    
    var newGroupName: (() -> Void)?
    var nameGroup: NameGroup?
    var iconCollectionViewCell = "iconCollectionViewCell"
    
//    массив с иконками для collectionView
    let iconImageArray: [UIImage] = [
        UIImage(systemName: "figure.highintensity.intervaltraining")!,
        UIImage(systemName: "laptopcomputer.and.iphone")!,
        UIImage(systemName: "graduationcap")!,
        UIImage(systemName: "person")!,
        UIImage(systemName: "list.bullet.clipboard")!,
        UIImage(systemName: "star")!,
        UIImage(systemName: "heart")!,
        UIImage(systemName: "tag")!
    ]
//    отслеживать выбранный индекс
    var isSelectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        setupLoyout()
    }
    
//    collectionIcon
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let itemSize = CGSize(width: 30, height: 30)
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(IconCollectionViewCell.self, forCellWithReuseIdentifier: "iconCollectionViewCell")
        collectionView.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
//    поле ввода текста
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont.systemFont(ofSize: 16)
//        view.backgroundColor = UIColor(red: 0.93, green: 0.92, blue: 0.91, alpha: 1.00)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //    заголовок
    private lazy var labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.text = "Новый список"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    текст "выберете иконку"
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Выберете иконку"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    текст укажите название
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Укажите название"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    кнопка сохранения
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "tray"), for: .normal)
        button.setTitle("Сохранить", for: .normal)
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
            
            if let selectedIndexPath = isSelectedIndexPath {
                let selectedImage = iconImageArray[selectedIndexPath.row]
                nameGroup?.iconNameGroup = selectedImage.pngData()
            }
            do {
                try context.save()
                self.newGroupName?()
                dismiss(animated: true)
            } catch {
                print("Ошибка сохранения данных в Core Data: \(error)")
            }
        } else {
            print("Name group nil")
            warningText()
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
        view.addSubview(iconLabel)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
    }
    
    private func warningText() {
        NotificationUtils.showWarning(on: self)
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).inset(17)
            make.top.equalTo(view.snp.top).inset(30)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(20)
            make.right.equalTo(view.snp.right).inset(20)
            make.height.equalTo(40)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(78)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
            make.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.top).inset(48)
            make.left.equalTo(view.snp.left).inset(17)
        }
        iconLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.top).inset(60)
            make.left.equalTo(view.snp.left).inset(17)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(iconLabel.snp.top).inset(40)
            make.left.equalTo(view.snp.left).inset(12)
            make.right.equalTo(view.snp.right).inset(12)
            make.height.equalTo(50)
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension NewGroupTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iconCollectionViewCell, for: indexPath) as! IconCollectionViewCell
        let image = iconImageArray[indexPath.item]
        let isSelect = indexPath == isSelectedIndexPath
        cell.configure(with: image, isSelected: isSelect)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelectedIndexPath = indexPath
        collectionView.reloadData()
    }
}
