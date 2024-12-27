//
//  NewTaskViewModel.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 13.12.2024.
//

import UIKit

final class NewTaskViewModel {
    
    private var taskProvider: NewTaskProvider?
    var nameGroup: NameGroup
    
    var selectedDate: Date? //выбранная дата
    var commentTask: String? //заметка к задаче
    var priorityTask: Int? //приоритет для задачи
    
    var onError: ((String) -> Void)? // уведомление об ошибке
    var onTaskSaved: (() -> Void)? // уведомление об успешном сохранении
    var onDateUpdated: ((String) -> Void)? // уведомление об обновлении цвета кнопки (если есть комментарий)
    var newTask: (() -> Void)? // уведомление для taskViewController о сохранении новой задачи
    
    init(taskProvider: NewTaskProvider, nameGroup: NameGroup) {
        self.taskProvider = taskProvider
        self.nameGroup = nameGroup
    }
    
    //    сохранение задачи в CoreData
    func saveTask(taskText: String?) {
        guard let taskText = taskText, !taskText.isEmpty else {
            onError?("Название задачи не может быть пустым")
            return
        }
        
        taskProvider?.createNewTask(
            name: taskText,
            date: selectedDate,
            notionTask: commentTask,
            group: nameGroup,
            priority: priorityTask,
            statusTask: false) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    self.onTaskSaved?()
                    self.newTask?()
                case .failure(let error):
                    self.onError?("Ошибка сохранения задачи в Core Data: \(error.localizedDescription)")
                }
            }
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
