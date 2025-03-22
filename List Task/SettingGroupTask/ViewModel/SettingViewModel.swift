//
//  SettingViewModel.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 10.01.2025.
//

import UIKit

final class SettingViewModel {
    
    private var settingDataProvider: SettingDataProvider
    var nameGroup: NameGroup

    var isSelectedIndexPathIcon: IndexPath? // отслеживать выбранный индекс иконки
    var isSelectedIndexPathColor: IndexPath? // отслеживать выбранный индекс цвета
    var saveSelectedColor: Int? // сохранить выбранный индекс с цветом в CoreData
        
    init(settingDataProvider: SettingDataProvider, nameGroup: NameGroup) {
        self.settingDataProvider = settingDataProvider
        self.nameGroup = nameGroup
        
        self.isSelectedIndexPathIcon = getSelectedIconIndex()
        self.saveSelectedColor = getSelectedColorIndex()
    }
    
//    получение списка иконок
    private func getIcons() -> [[UIImage]] {
        return MoreIconsViewModel().section.map{ $0.icons }
    }
    
//    отпределение индекса ранее сохраненной иконки для отображение на settiongView
    func getSelectedIconIndex() -> IndexPath? {
        let icons = getIcons()
        guard let savedIconData = nameGroup.iconNameGroup else { return nil }

        for (sectionIndex, section) in icons.enumerated() {
            for (itemIndex, icon) in section.enumerated() {
                if icon.pngData() == savedIconData {
                    return IndexPath(item: itemIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }
    
//    получение индекса сохраненного цвета
    func getSelectedColorIndex() -> Int? {
        return Int(nameGroup.colorIcon)
    }
    
//    отпределение индекса ранее сохраненной иконки для отображение на settiongView
    func getSelectedIconIndex(icons: [[UIImage]]) -> IndexPath? {
        guard let savedIconData = nameGroup.iconNameGroup else { return nil }

        for (sectionIndex, section) in icons.enumerated() {
            for (itemIndex, icon) in section.enumerated() {
                if icon.pngData() == savedIconData {
                    return IndexPath(item: itemIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }
    
//    выбор цвета кнопки "Еще"
    func updateIconsButtonTapped(indexPath: IndexPath) -> UIColor {
        if let indexPath = isSelectedIndexPathIcon, indexPath.section > 0 {
            return UIColor.systemYellow // подкрашиваем кнопку "Еще" в желтый цвет
//            print(indexPath)
        } else {
            return UIColor.lightGray
//            print("Индекс меньше 0")
        }
    }
    
    /// Сохранение изменной группы задач
    /// - Parameters:
    ///   - newName: новое имя задачи
    ///   - completion: completion
    func saveChengeGroupTask(newName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let newSelectedIconData: Data? = {
            if let selectedIndexPath = isSelectedIndexPathIcon {
                let selectedImage = getIcons()[selectedIndexPath.section][selectedIndexPath.item]
//                let selectedImage = icons[selectedIndexPath.row]
//                print("Сохраненный индекс: \(selectedIndexPath)")
                return selectedImage.pngData()
            } else {
                print("Иконка не найденна")
                return nameGroup.iconNameGroup
            }
        }()
        
        settingDataProvider.changeGroupTask(
            exestiongGroup: nameGroup,
            newName: newName,
            newIcon: newSelectedIconData,
            colorIcon: Int64(saveSelectedColor ?? Int(nameGroup.colorIcon)),
            completion: completion)
    }
}

