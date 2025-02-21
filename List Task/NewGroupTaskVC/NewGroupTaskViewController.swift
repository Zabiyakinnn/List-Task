//
//  NewGroupTaskViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 01.11.2024.
//

import UIKit
import SnapKit

final class NewGroupTaskViewController: UIViewController, UITextViewDelegate {
    
    var newGroupName: (() -> Void)? // уведоление о сохранение новой группы
    
    private var newGroupView = NewGroupView()
    var nameGroup: NameGroup?
    var iconCollectionViewCell = "iconCollectionViewCell"

    var isSelectedIndexPath: IndexPath? // отслеживать выбранный индекс
    
    //    массив с иконками для collectionView
    let icons = IconImageArray.shared.icons

    //    MARK: - LoadView
    override func loadView() {
        self.view = newGroupView
    }
    
    //    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        
        newGroupView.collectionView.dataSource = self
        newGroupView.collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newGroupView.textView.becomeFirstResponder()
    }
    
    private func setupButton() {
        newGroupView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    //    сохранения группы для задач
    @objc private func saveButtonTapped() {
        guard let groupName = newGroupView.textView.text, !groupName.isEmpty else {
            warningText()
            return
        }
        
        let selectedIconData: Data? = {
            if let selectedIndexPath = isSelectedIndexPath {
                let selectedImage = icons[selectedIndexPath.row]
                return selectedImage.pngData()
            }
            return nil
        }()
        
        if selectedIconData == nil {
            warningImage()
            return
        }
        
        CoreDataManagerNameGroup.shared.saveNewGroupCoreData(
            name: groupName,
            iconNameGroup: selectedIconData,
            existingGroup: nameGroup,
            iconColor: 33) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    self.newGroupName?()
                    self.dismiss(animated: true)
                case .failure(let error):
                    print("Ошибка сохранения группы для задач в Core Data: \(error.localizedDescription)")
                }
            }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension NewGroupTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newGroupView.collectionView.dequeueReusableCell(withReuseIdentifier: iconCollectionViewCell, for: indexPath) as! IconCollectionViewCell
        let image = icons[indexPath.item]
        let isSelect = indexPath == isSelectedIndexPath
        cell.configure(with: image, isSelected: isSelect)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelectedIndexPath = indexPath
        newGroupView.collectionView.reloadData()
    }
}

//MARK: - func
extension NewGroupTaskViewController {
    private func warningText() {
        NotificationUtils.showWarning(on: self, text: "Заполните поле с названием группы")
    }
    
    private func warningImage() {
        NotificationUtils.showWarning(on: self, text: "Выберете изображение")
    }
}
