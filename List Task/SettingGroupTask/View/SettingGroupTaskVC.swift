//
//  SettingGroupTaskVC.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.01.2025.
//

import UIKit

final class SettingGroupTaskVC: UIViewController {
    
    private var settingGroupTaskView = SettingGroupTaskView()
    
    let icons = IconImageArray.shared.icons // иконки
    let colors = ColorPalette.colors // цвета
    
    var iconCollectionViewCell = "iconCollectionViewCell"
    var colorCell = "colorCell"
    private var viewModel: SettingViewModel
    
    var isSelectedIndexPathIcon: IndexPath? // отслеживать выбранный индекс иконки
    var isSelectedIndexPathColor: IndexPath? // отслеживать выбранный индекс цвета
    var saveSelectedColor: Int? // сохранить выбранный индекс с цветом в CoreData
    
    var onGroupSaved: (() -> Void)? // уведомление об успешном сохранении

    //    MARK: - Init
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - LoadView
    override func loadView() {
        self.view = settingGroupTaskView
    }
    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        settingGroupTaskView.collectionViewIcon.dataSource = self
        settingGroupTaskView.collectionViewIcon.delegate = self
        
        settingGroupTaskView.collectionViewColor.dataSource = self
        settingGroupTaskView.collectionViewColor.delegate = self
        
        setupBinding()
        setupButton()
        
    }
    
//    настрйка зависимостей
    func setupBinding() {
        settingGroupTaskView.contentView(name: viewModel.nameGroup.name ?? "Название группы")
        
        isSelectedIndexPathIcon = viewModel.getSelectedIconIndex(icons: icons) // получение индекса сохраненной иконки
        settingGroupTaskView.collectionViewIcon.reloadData()
        
        if let savedColorIndex = viewModel.getSelectedColorIndex() { // получение индекса сохраненного цвета
            isSelectedIndexPathColor = IndexPath(item: savedColorIndex, section: 0)
        }
        settingGroupTaskView.collectionViewColor.reloadData()
    }
    
//    MARK: - Button
    private func setupButton() {
        settingGroupTaskView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
//    сохранение задачи
    @objc func saveButtonTapped() {
        guard let newNameText = settingGroupTaskView.textView.text, !newNameText.isEmpty else {
            warningText()
            return
        }
        
        let newSelectedIconData: Data? = {
            if let selectedIndexPath = isSelectedIndexPathIcon {
                let selectedImage = icons[selectedIndexPath.row]
                return selectedImage.pngData()
            }
            return nil
        }()
        
        viewModel.saveChangeGroupTask(
            group: viewModel.nameGroup,
            newName: newNameText,
            newIcon: newSelectedIconData,
            colorIcon: Int64(saveSelectedColor ?? 0)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
//                print("Изменния группы сохранены. Новое имя \(newNameText), новая иконка \(newSelectedIconData), новый цвет \(saveSelectedColor)")
                onGroupSaved?()
                dismiss(animated: true)
            case .failure(let error):
                print("Ошибка сохранения изменений в CoreData: \(error.localizedDescription)")
            }
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SettingGroupTaskVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == settingGroupTaskView.collectionViewColor {
            return colors.count
        } else if collectionView == settingGroupTaskView.collectionViewIcon {
            return icons.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == settingGroupTaskView.collectionViewColor {
            guard let cell = settingGroupTaskView.collectionViewColor.dequeueReusableCell(withReuseIdentifier: colorCell, for: indexPath) as? ColorCell else {
                return UICollectionViewCell()
            }
            let color = colors[indexPath.item]
            let isSelect = indexPath == isSelectedIndexPathColor
            cell.configure(with: color, isSilected: isSelect)
            return cell
        } else if collectionView == settingGroupTaskView.collectionViewIcon {
            guard let cell = settingGroupTaskView.collectionViewIcon.dequeueReusableCell(withReuseIdentifier: iconCollectionViewCell, for: indexPath) as? IconCollectionViewCell else {
                return UICollectionViewCell()
            }
            let image = icons[indexPath.item]
            let isSelect = indexPath == isSelectedIndexPathIcon
            cell.configure(with: image, isSelected: isSelect)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == settingGroupTaskView.collectionViewIcon {
            isSelectedIndexPathIcon = indexPath
            collectionView.reloadData()
        } else if collectionView == settingGroupTaskView.collectionViewColor {
            isSelectedIndexPathColor = indexPath
            saveSelectedColor = indexPath.item
            print("Выбранный индекс \(saveSelectedColor ?? 0)")
            
            
//            let selectedColor = colors[indexPath.item]
//            print("Выбранный цвет \(selectedColor)")
            
            collectionView.reloadData()
        }
    }
}

//MARK: - func
extension SettingGroupTaskVC {
    private func warningText() {
        NotificationUtils.showWarning(on: self, text: "Название группы не может быть пустым")
    }
}

////MARK: - UIColor
//extension UIColor {
////    преобразование цвета в строку
//    func hexToString() -> String {
//        var r: CGFloat = 0
//        var g: CGFloat = 0
//        var b: CGFloat = 0
//        var a: CGFloat = 0
//
//        self.getRed(&r, green: &g, blue: &b, alpha: &a)
//        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
//    }
//}
