//
//  NewCommentTaskViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 11.12.2024.
//

import UIKit

final class NewCommentTaskViewController: UIViewController {
    
    var newCommentTaskView = NewCommentTaskView()
    var onColorIconComment: ((Bool) -> Void)? //если заметка введена пользователем меняем цвет иконки кнопки в newTaskVC
    
    private var isSaveButtonTapped = false
    
//    MARK: - LoadView
    override func loadView() {
        self.view = newCommentTaskView
    }
    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    
        newCommentTaskView.textView.delegate = self
        setupButton()
    }
    
//    MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        newCommentTaskView.textView.becomeFirstResponder()
    }
    
//    setupButton
    private func setupButton() {
        newCommentTaskView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        let hasText = !(newCommentTaskView.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) 
        
        if hasText {
            newCommentTaskView.textView.text = newCommentTaskView.textView.text
            onColorIconComment?(true)
        } else {
            onColorIconComment?(false)
        }
        
        isSaveButtonTapped = true
        self.dismiss(animated: true)
    }
}

//MARK: - UITextViewDelegate
extension NewCommentTaskViewController: UITextViewDelegate {
    
//    проверяем есть ли текст и уведомляем об этом
    func textViewDidChange(_ textView: UITextView) {
        let hasText = !(textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        onColorIconComment?(hasText)
    }
}
