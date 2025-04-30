//
//  ChangeTaskViewModel.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 24.04.2025.
//

import UIKit

final class ChangeTaskViewModel {
    
    private var changeTaskProvider: ChangeTaskProvider
    let nameGroup: NameGroup
    let taskList: TaskList
    
    var selectedDate: Date? //выбранная дата
    var commentTask: String? //заметка к задаче
    var priorityTask: Int? //приоритет для задачи
    var statusTask: Bool? // статус для задачи
    
    var onDateUpdated: ((String) -> Void)? // уведомление об обновлении цвета кнопки (если выбранна дата)
    var onChangeTask: (() -> Void)?
    
    init(nameGroup: NameGroup, taskList: TaskList, changeTaskProvider: ChangeTaskProvider) {
        self.nameGroup = nameGroup
        self.taskList = taskList
        self.changeTaskProvider = changeTaskProvider
    }
    
    
    /// Сохарнение изменной задачи
    /// - Parameter nameTask: имя задачи
    func changeSaveTask(nameTask: String?) {
        
        guard let taskNameText = nameTask, !taskNameText.isEmpty else {
            print("Задача не может быть с пустым именем")
            return
        }
        
        changeTaskProvider.changeTask(
            task: taskList,
            newNameTask: taskNameText,
            newDate: selectedDate,
            newNotionTask: commentTask,
            newPriority: priorityTask,
            newGroup: nameGroup,
            newStatusTask: statusTask,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    onChangeTask?()
                case .failure(let error):
                    print("Ошибка сохранения задачи в CoreData \(error.localizedDescription)")
                }
            })
    }
    
//    если есть дата у задачи форматируем ее в строку и отображаем на кнопке
    func formatterDate(date: Date) -> String {
        let date = date
        let forrmater = DateFormatter()
        forrmater.locale = Locale(identifier: "ru_RU")
        forrmater.dateFormat = "d MMM"
        let today = Calendar.current.startOfDay(for: Date()) // сегодняшняя дата
        let selectedDay = Calendar.current.startOfDay(for: date) // выбранная дата
        let difference = Calendar.current.dateComponents([.day], from: today, to: selectedDay).day
        
        let formatterDate: String
        switch difference {
        case 0: formatterDate = "Сегодня"
        case 1: formatterDate = "Завтра"
        case -1: formatterDate =  "Вчера"
        default: formatterDate = forrmater.string(from: date)
        }
        return formatterDate
    }
    
    //    форматирование выбранной даты
    func updateSelectedDate(date: Date) {
        selectedDate = date
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM"
        let today = Calendar.current.startOfDay(for: Date()) // сегодняшняя дата
        let selectedDay = Calendar.current.startOfDay(for: date) // выбранная дата
        let difference = Calendar.current.dateComponents([.day], from: today, to: selectedDay).day
        
        let formatterDate: String
        switch difference {
        case 0: formatterDate = "Сегодня"
        case 1: formatterDate = "Завтра"
        case -1: formatterDate =  "Вчера"
        default: formatterDate = formatter.string(from: date)
        }
        
        onDateUpdated?(formatterDate)
    }
}

