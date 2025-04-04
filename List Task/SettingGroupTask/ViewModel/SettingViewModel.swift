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
//    var saveSelectedColor: Int? // сохранить выбранный индекс с цветом в CoreData
        
    init(settingDataProvider: SettingDataProvider, nameGroup: NameGroup) {
        self.settingDataProvider = settingDataProvider
        self.nameGroup = nameGroup
        
//        self.isSelectedIndexPathIcon = getSelectedIconIndex()
        self.isSelectedIndexPathIcon = getSelectedIconIndex(icons: getIcons())
        self.isSelectedIndexPathIcon = getSelectedColorIndex(color: getColor())
    }
    
//    получение списка иконок
    private func getIcons() -> [[UIImage]] {
        return MoreIconsViewModel().section.map{ $0.icons }
    }
    
    private func getColor() -> [[UIColor]] {
        return MoreColorViewModel().section.map{ $0.color }
    }
    
//    получение индекса сохраненного цвета
    func getSelectedColorIndex(color: [[UIColor]]) -> IndexPath? {
        guard let savedColorData = nameGroup.colorIcon else { return nil }
        
        if let savedColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
            
            // Ищем индекс цвета в двумерном массиве
            for (sectionIndex, colorSection) in color.enumerated() {
                if let rowIndex = colorSection.firstIndex(of: savedColor) {
                    return IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }
    
//    отпределение индекса ранее сохраненной иконки для отображение на settingView
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
    
//    выбор цвета кнопки "Еще" для выбора иконок
    func updateIconsButtonTapped(indexPath: IndexPath) -> UIColor {
        if let indexPath = isSelectedIndexPathIcon, indexPath.section > 0 {
            return UIColor.systemYellow // подкрашиваем кнопку "Еще" в желтый цвет
//            print(indexPath)
        } else {
            return UIColor.lightGray
//            print("Индекс меньше 0")
        }
    }
    
//    выбор цвета кнопки "Еще" для выбора цветов
    func updateColorButtonTapped(indexPath: IndexPath) -> UIColor {
        if let indexPath = isSelectedIndexPathColor, indexPath.section > 0 {
            return UIColor.systemYellow
        } else {
            return UIColor.lightGray
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
                print("Иконка не найденна, применяем прошлую")
                return nameGroup.iconNameGroup
            }
        }()
        
        let newSelectedColorData: Data? = {
            if let selectedIndexPath = isSelectedIndexPathColor {
                let selectedColor = getColor()[selectedIndexPath.section][selectedIndexPath.item]
                return try? NSKeyedArchiver.archivedData(withRootObject: selectedColor, requiringSecureCoding: false)
            } else {
                print("Цвет не выбран, оставляем прошлый")
                return nameGroup.colorIcon
            }
        }()
        
        settingDataProvider.changeGroupTask(
            exestiongGroup: nameGroup,
            newName: newName,
            newIcon: newSelectedIconData,
            colorIcon: newSelectedColorData,
            completion: completion)
    }
    
    func deleteGroup(by uuid: UUID, completion: @escaping(Result<Void, Error>) -> Void) {
        settingDataProvider.deleteGroup(by: uuid, completion: completion)
    }
}

