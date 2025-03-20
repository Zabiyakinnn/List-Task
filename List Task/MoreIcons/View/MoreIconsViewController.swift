//
//  MoreIconsViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 14.03.2025.
//

import UIKit

final class MoreIconsViewController: UIViewController {
    
    private var moreIconsView = MoreIconsView()
    private var viewModel = MoreIconsViewModel()
    
    var iconCollectionViewCell = "iconCollectionViewCell"
    var isSelectedIndexPath: IndexPath? // отслеживать выбранный индекс
        
    var onNewIconSelected: ((UIImage, IndexPath) -> Void)?

    
//    MARK: LoadView
    override func loadView() {
        self.view = moreIconsView
    }
    
//    MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()

        moreIconsView.collectionView.delegate = self
        moreIconsView.collectionView.dataSource = self
    }
    
//    MARK: Button
    private func setupButton() {
        moreIconsView.closeVCButton.addTarget(self, action: #selector(closeVCButtonTapped), for: .touchUpInside)
    }
    
//    закрыть ViewController
    @objc private func closeVCButtonTapped() {
        dismiss(animated: true)
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MoreIconsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Количество секций (групп иконок)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.section.count
    }
    
    // Количество элементов в каждой секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.section[section].icons.count
    }
    
    //создание ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moreIconsView.collectionView.dequeueReusableCell(withReuseIdentifier: iconCollectionViewCell, for: indexPath) as! IconCollectionViewCell
        let image = viewModel.section[indexPath.section].icons[indexPath.item]
        let isSelect = indexPath == isSelectedIndexPath
        cell.configure(with: image, isSelected: isSelect)
        return cell
    }
    
    // заголовок для секции
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderReusableView
            
            header.labelHeadline.text = viewModel.section[indexPath.section].title
            return header
        }
        return UICollectionViewCell()
    }
     
    // выбираем изобраджение
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelectedIndexPath = indexPath
        let selectedImage = viewModel.section[indexPath.section].icons[indexPath.item]
        print("Выбранный индекс внутри MoreIconsViewController: \(indexPath)")
        onNewIconSelected?(selectedImage, indexPath)
        moreIconsView.collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40) // высота заголовка
    }
}
