//
//  SortingViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 18.01.2025.
//

import UIKit

final class SortingViewController: UIViewController {
    
    private var sortingView = SortingView()
    private let sotringViewCell = "sotringViewCell"
    private var selectedIndexPath: IndexPath?

    var onSortingSelected: ((String) -> Void)? //передача выбранной сортировки задач
    var selectedSortingOption: String? // хранение выбранной сортировки 
    
//    MARK: - LoadView
    override func loadView() {
        self.view = sortingView
    }
    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortingView.tableView.delegate = self
        sortingView.tableView.dataSource = self
        setupButton()
    }
    
//    MARK: - SetupButton
    private func setupButton() {
        sortingView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SortingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingView.sorting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sortingView.tableView.dequeueReusableCell(withIdentifier: sotringViewCell, for: indexPath) as? SortingViewCell
        
        let sorting = sortingView.sorting[indexPath.row]
        cell?.sortingLabel.text = sorting
        cell?.checkmarkSorting.isHidden = indexPath != selectedIndexPath
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        сбросить предъидущий выбор
        if let previousIndexPath = selectedIndexPath {
            if let previousCell = tableView.cellForRow(at: previousIndexPath) as? SortingViewCell {
                previousCell.checkmarkSorting.isHidden = true
            }
        }
//        устанавливаем новый выбор
        selectedIndexPath = indexPath
        if let currentCell = tableView.cellForRow(at: indexPath) as? SortingViewCell {
            currentCell.checkmarkSorting.isHidden = false
        }
        
        let sortingOption = sortingView.sorting[indexPath.row] // получение выбранной сортировки
        print("Выбранная сортировка задач \(sortingOption)")
        
        onSortingSelected?(sortingOption) // вызов замыкания
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
