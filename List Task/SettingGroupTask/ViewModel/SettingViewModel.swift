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
        
    init(settingDataProvider: SettingDataProvider, nameGroup: NameGroup) {
        self.settingDataProvider = settingDataProvider
        self.nameGroup = nameGroup
    }
    
//    отпределение индекса ранее сохраненной иконки для отображение на settiongView
    func getSelectedIconIndex(icons: [UIImage]) -> IndexPath? {
        guard let iconData = nameGroup.iconNameGroup else { return nil }
        
        for (index, icon) in icons.enumerated() {
            if let iconPngData = icon.pngData(), iconPngData == iconData {
                return IndexPath(item: index, section: 0)
            }
        }
        return nil
    }
    
//    определение индекса для сохраненного цвета
    func getSelectedColorIndex() -> Int? {
        return Int(nameGroup.colorIcon)
    }
    
    /// сохранение измененной группы задач
    /// - Parameters:
    ///   - newName: новое имя
    ///   - newIcon: новая иконка
    ///   - completion: completion
    func saveChangeGroupTask(group: NameGroup, newName: String, newIcon: Data?, colorIcon: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        settingDataProvider.changeGroupTask(
            exestiongGroup: group,
            newName: newName,
            newIcon: newIcon,
            colorIcon: colorIcon,
            completion: completion
        )
    }
}
