//
//  SettingGroupTaskVC.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.01.2025.
//

import UIKit

final class SettingGroupTaskVC: UIViewController {
    
    private var settingGroupTaskView = SettingGroupTaskView()
    
    private var moreIconsViewModel = MoreIconsViewModel()
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
        
        let icons = moreIconsViewModel.section.map { $0.icons }
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
        settingGroupTaskView.moreIconsButton.addTarget(self, action: #selector(moreIconsButtonTapped), for: .touchUpInside)
    }
    
//    сохранение задачи
    @objc func saveButtonTapped() {
        guard let newNameText = settingGroupTaskView.textView.text, !newNameText.isEmpty else {
            warningText()
            return
        }
        
        let newSelectedIconData: Data? = {
            if let selectedIndexPath = isSelectedIndexPathIcon {
                let selectedImage = moreIconsViewModel.section[selectedIndexPath.section].icons[selectedIndexPath.item]
//                let selectedImage = icons[selectedIndexPath.row]
                print("Сохраненный индекс: \(selectedIndexPath)")
                return selectedImage.pngData()
            } else {
                print("Иконка не найдена")
                let imageSave = viewModel.nameGroup.iconNameGroup
                return imageSave
            }
        }()
        
        viewModel.saveChangeGroupTask(
            group: viewModel.nameGroup,
            newName: newNameText,
            newIcon: newSelectedIconData,
            colorIcon: Int64(saveSelectedColor ?? Int(viewModel.nameGroup.colorIcon))) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                onGroupSaved?()
//                print("Иконка измененена на \(newSelectedIconData)")
                dismiss(animated: true)
            case .failure(let error):
                print("Ошибка сохранения изменений в CoreData: \(error.localizedDescription)")
            }
        }
    }
    
//    переход на экран выбора сортировки задач
    @objc func sortingView() {
        let sortingVC = SortingViewController()
        present(sortingVC, animated: true)
    }
    
//    переход на экран с большим кол-вом иконок
    @objc private func moreIconsButtonTapped() {
        let moreIconsVC = MoreIconsViewController()
        moreIconsVC.isSelectedIndexPath = isSelectedIndexPathIcon
//        print("Индекс выбранной иконки: \(isSelectedIndexPathIcon)")
        
        moreIconsVC.onNewIconSelected = { [weak self] selectedImage, selectedIndexPath in
            guard let self = self else { return }
            self.isSelectedIndexPathIcon = selectedIndexPath
//            print("Выбрана новая иконка: \(selectedIndexPath)")
            self.settingGroupTaskView.collectionViewIcon.reloadData()
        }
        
        present(moreIconsVC, animated: true)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SettingGroupTaskVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == settingGroupTaskView.collectionViewColor {
            return colors.count
        } else if collectionView == settingGroupTaskView.collectionViewIcon {
//            let icons = moreIconsViewModel.section.first?.icons ?? []
//            return icons.count
            return moreIconsViewModel.section[section].icons.count
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
            let icons = moreIconsViewModel.section[indexPath.section].icons
            let image = icons[indexPath.item]
            let isSelect = indexPath == isSelectedIndexPathIcon
//            print("Ячейка: \(indexPath), Выбранный индекс: \(String(describing: isSelectedIndexPathIcon)), Совпадение: \(isSelect)")
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
            collectionView.reloadData()
        }
    }
}

//MARK: - warning
extension SettingGroupTaskVC {
    private func warningText() {
        NotificationUtils.showWarning(on: self, text: "Название группы не может быть пустым")
    }
}
