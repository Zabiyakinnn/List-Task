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
    
    var onTaskUpdated: (() -> Void)? //уведомлние об изменении списка задач
    var onTaskDelete: (() -> Void)? //уведомление об удалении задачи
    //    var onCommentToTask: (() -> Void)?
    
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
    
    //    обновление статуса задачи (выполненно/ не выполненно)
    func updateTaskStatus(task: String, newStatus: Bool, completion: @escaping(Result<Void, Error>) -> Void) {
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
    
    //    удаление задачи
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
    
    //    сохранение комментария для задачи
    func saveComment(nameTask: String, comment: String?, for indexPath: IndexPath, completion: @escaping(Result<Void, Error>) -> Void) {
        taskDataProvider.saveComment(
            nameTask: nameTask,
            comment: comment,
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
}
