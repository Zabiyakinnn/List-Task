//
//  TaskViewModel.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 14.12.2024.
//

import UIKit

final class TaskViewModel {
    
    private var taskDataProvider: TaskDataProvider
    var nameGroup: NameGroup
    
    var selectedDate: Date? //выбранная дата в календаре
    
    var onTaskUpdated: (() -> Void)? //уведомлние об изменении списка задач
    var onTaskDelete: (() -> Void)? //уведомление об удалении задачи
    var onNewDateTask: ((Date) -> Void)? //уведоление о новой дате для задачи
    var onNewPriorityTask: ((Int) -> Void)? //уведомление об изменении приоритета задачи
    
    init(taskDataProvider: TaskDataProvider, nameGroup: NameGroup) {
        self.taskDataProvider = taskDataProvider
        self.nameGroup = nameGroup
    }
    
    //    MARK: - Работа с задачами
    //    обновление данных
    func reloadTask() {
        taskDataProvider.perfomFetch()
        onTaskUpdated?()
    }
    
    //    получение кол-ва задач
    func countTask() -> Int {
        return taskDataProvider.numberOfTask()
    }
    
    //    получаем список задач
    func task(at indexPath: IndexPath) -> TaskList? {
        return taskDataProvider.task(at: indexPath)
    }
    
    //    создание новой задачи
    func createNewTaskViewModel() -> NewTaskViewModel {
        let newTaskProvider = NewTaskProvider()
        let newTaskViewModel = NewTaskViewModel(taskProvider: newTaskProvider, nameGroup: nameGroup)
        return newTaskViewModel
    }
    
    func presentSortingScreen() {
        let sortingVC = SortingViewController()
        
        sortingVC.onSortingSelected = { [weak self] selectedSorting in
            guard let self = self else { return }
            
        }
    }
    
//    MARK: - Изменение статуса задачи (выполненно/ не выполенно)
    /// обновление статуса в CoreData
    /// - Parameters:
    ///   - task: задача
    ///   - newStatus: новый стауст
    ///   - completion: completion
    private func updateTaskStatus(task: String, newStatus: Bool, completion: @escaping(Result<Void, Error>) -> Void) {
        taskDataProvider.updateTaskStatus(
            nameTask: task,
            newStatus: newStatus) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    self.reloadTask()
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure((error)))
                }
            }
    }
        
    /// обновление статуса задачи во ViewController
    /// - Parameters:
    ///   - indexPath: indexPath
    ///   - newStatus: новый статус
    ///   - completion: completion
    func changeStatusButton(at indexPath: IndexPath, to newStatus: Bool, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let task = task(at: indexPath) else {
            completion(.failure(NSError(domain: "Задача не найденна", code: 404)))
            return
        }
        updateTaskStatus(task: task.nameTask ?? "", newStatus: newStatus, completion: completion)
    }
    
//    MARK: - Удалние задачи
    /// удаление задачи из CoreData
    /// - Parameters:
    ///   - indexPath: indexPath
    ///   - completion: completion
    func deleteTask(at indexPath: IndexPath, completion: @escaping(Result<Void, Error>) -> Void) {
        if let taskToDelete = task(at: indexPath) {
            taskDataProvider.deleteTask(
                taskList: taskToDelete) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success():
                        self.reloadTask()
                        self.onTaskDelete?()
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure((error)))
                    }
                }
        }
    }

//    MARK: - Комменатрии к задаче
    /// сохранение комментария для задачи в CoreData
    /// - Parameters:
    ///   - nameTask: имя задачи
    ///   - comment: новый комментарий
    ///   - indexPath: indexPath
    ///   - completion: completion
    private func saveCommentCoreData(nameTask: String, newComment: String?, for indexPath: IndexPath, completion: @escaping(Result<Void, Error>) -> Void) {
        taskDataProvider.saveComment(
            nameTask: nameTask,
            comment: newComment,
            for: indexPath) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    reloadTask()
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure((error)))
                }
            }
    }
    
    /// обновление комментария во viewController
    /// - Parameters:
    ///   - indexPath: indexPath
    ///   - newComment: новый комментарий
    ///   - completion: completion
    func saveComment(at indexPath: IndexPath, newComment: String?, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let task = task(at: indexPath) else {
            completion(.failure(NSError(domain: "Задача не найденна", code: 404)))
            return
        }
        saveCommentCoreData(nameTask: task.nameTask ?? "", newComment: newComment, for: indexPath, completion: completion)
    }
    
//    MARK: - Приоритет для задачи
    /// сохранение нового выбранного приоритета для задачи
    /// - Parameters:
    ///   - nameTask: имя задачи
    ///   - priority: приоритет
    ///   - indexPath: indexPath
    ///   - completion: completion
    private func savePriorityTaskCoreDate(nameTask: String, priority: Int16, for indexPath: IndexPath, completion: @escaping(Result<Void, Error>) -> Void) {
        taskDataProvider.savePriorityTask(
            nameTask: nameTask,
            priority: priority,
            for: indexPath) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    reloadTask()
                    self.onNewPriorityTask?(Int(priority))
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure((error)))
                }
            }
    }
    
    /// обновление приоритета во viewController
    /// - Parameters:
    ///   - indexPath: indexPath
    ///   - newPriority: новый приоритет
    ///   - completion: completion
    func savePriorityTask(at indexPath: IndexPath, newPriority: Int, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let task = task(at: indexPath) else {
            completion(.failure(NSError(domain: "Задача не найденна", code: 404)))
            return
        }
        savePriorityTaskCoreDate(nameTask: task.nameTask ?? "", priority: Int16(newPriority), for: indexPath, completion: completion)
    }
    
//    MARK: Date Callendar LeadingSwipe
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
        
        onNewDateTask?(date)
    }
        
    /// сохранение новой даты для задачи в CoreData
    /// - Parameters:
    ///   - nameTask: имя задачи
    ///   - newDate: новая дата
    ///   - indexPath: indexPath
    ///   - compltion: completion
    private func saveNewDateTaskCoreData(nameTask: String, newDate: Date?, for indexPath: IndexPath, compltion: @escaping(Result<Void, Error>) -> Void) {
        taskDataProvider.saveNewDateTask(
            nameTask: nameTask,
            newDate: newDate,
            for: indexPath) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    reloadTask()
                    compltion(.success(()))
                case .failure(let error):
                    compltion(.failure((error)))
                }
            }
    }
        
    /// сохранение новой даты
    /// - Parameters:
    ///   - indexPath: indexPath
    ///   - newDate: новая дата
    ///   - completion: completion
    func saveNewDate(at indexPath: IndexPath, newDate: Date, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let task = task(at: indexPath) else {
            completion(.failure(NSError(domain: "Задача не найденна", code: 404)))
            return
        }
        saveNewDateTaskCoreData(nameTask: task.nameTask ?? "", newDate: newDate, for: indexPath, compltion: completion)
    }
}
