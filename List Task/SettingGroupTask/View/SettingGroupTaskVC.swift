//
//  SettingGroupTaskVC.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.01.2025.
//

import UIKit

final class SettingGroupTaskVC: UIViewController {
    
    private var settingGroupTaskView = SettingGroupTaskView()
    private var viewModel: SettingViewModel
    private var moreIconsViewModel = MoreIconsViewModel()
    private var moreColorViewModel = MoreColorViewModel()
    private var moreIconsVC = MoreIconsViewController()
    
    let colors = ColorPalette.colors // цвета
//    let colors = MoreColorViewModel().section
    
    var iconCollectionViewCell = "iconCollectionViewCell"
    var colorCell = "colorCell"
    
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
    
//    MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = viewModel.isSelectedIndexPathIcon {
            settingGroupTaskView.moreIconsButton.tintColor = viewModel.updateIconsButtonTapped(indexPath: indexPath)
        }
        moreIconsVC.selectedColor = { [weak self] indexPath in
            guard let self = self else { return }
            settingGroupTaskView.moreIconsButton.tintColor = viewModel.updateIconsButtonTapped(indexPath: indexPath)
        }
    }
    
    
//    настрйка зависимостей
    func setupBinding() {
        settingGroupTaskView.contentView(name: viewModel.nameGroup.name ?? "Название группы")
        
        let icons = moreIconsViewModel.section.map { $0.icons }
        viewModel.isSelectedIndexPathIcon = viewModel.getSelectedIconIndex(icons: icons)  // получение индекса сохраненной иконки

        settingGroupTaskView.collectionViewIcon.reloadData()
        
        if let savedColorIndex = viewModel.getSelectedColorIndex() { // получение индекса сохраненного цвета
            viewModel.isSelectedIndexPathColor = IndexPath(item: savedColorIndex, section: 0)
        }
        settingGroupTaskView.collectionViewColor.reloadData()
    }
    
    
//    MARK: - Button
    private func setupButton() {
        settingGroupTaskView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        settingGroupTaskView.moreIconsButton.addTarget(self, action: #selector(moreIconsButtonTapped), for: .touchUpInside)
        settingGroupTaskView.moreColorButton.addTarget(self, action: #selector(moreColorButtonTapped), for: .touchUpInside)
    }
    
//    сохранение задачи
    @objc func saveButtonTapped() {
        guard let newNameText = settingGroupTaskView.textView.text, !newNameText.isEmpty else {
            warningTextNoNameGroup()
            return
        }
        
        viewModel.saveChengeGroupTask(newName: newNameText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                onGroupSaved?()
                dismiss(animated: true)
            case .failure(let error):
                warningTextErrorServer()
                print("Ошибка сохранения изменений в CoreData: \(error.localizedDescription)")
            }
        }
    }
    
//    переход на экран с большим кол-вом иконок
    @objc private func moreIconsButtonTapped() {
        moreIconsVC.isSelectedIndexPath = viewModel.isSelectedIndexPathIcon
//        print("Индекс выбранной иконки: \(isSelectedIndexPathIcon)")
        
        moreIconsVC.onNewIconSelected = { [weak self] _, selectedIndexPath in
            guard let self = self else { return }
            viewModel.isSelectedIndexPathIcon = selectedIndexPath
//            print("Выбрана новая иконка: \(selectedIndexPath)")
            self.settingGroupTaskView.collectionViewIcon.reloadData()
        }
        
        present(moreIconsVC, animated: true)
    }
    
//    переход на экран с болим кол-вом цветов
    @objc private func moreColorButtonTapped() {
        let moreColorVC = MoreColorViewController()
        present(moreColorVC, animated: true)
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
            let isSelect = indexPath == viewModel.isSelectedIndexPathColor
            cell.configure(with: color, isSilected: isSelect)
            return cell
        } else if collectionView == settingGroupTaskView.collectionViewIcon {
            guard let cell = settingGroupTaskView.collectionViewIcon.dequeueReusableCell(withReuseIdentifier: iconCollectionViewCell, for: indexPath) as? IconCollectionViewCell else {
                return UICollectionViewCell()
            }
            let icons = moreIconsViewModel.section[indexPath.section].icons
            let image = icons[indexPath.item]
            let isSelect = indexPath == viewModel.isSelectedIndexPathIcon
//            print("Ячейка: \(indexPath), Выбранный индекс: \(String(describing: isSelectedIndexPathIcon)), Совпадение: \(isSelect)")
            cell.configure(with: image, isSelected: isSelect)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == settingGroupTaskView.collectionViewIcon {
            viewModel.isSelectedIndexPathIcon = indexPath
            collectionView.reloadData()
        } else if collectionView == settingGroupTaskView.collectionViewColor {
            viewModel.isSelectedIndexPathColor = indexPath
            viewModel.saveSelectedColor = indexPath.item
            collectionView.reloadData()
        }
    }
}

//MARK: Warning
extension SettingGroupTaskVC {
    private func warningTextNoNameGroup() {
        NotificationUtils.showWarning(on: self, text: "Название группы не может быть пустым")
    }
    private func warningTextErrorServer() {
        NotificationUtils.showWarning(on: self, text: "Ошибка сервера при сохранении задачи. Попробуйте перезапустить приложение")
    }
}
