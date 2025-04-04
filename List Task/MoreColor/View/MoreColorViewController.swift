//
//  MoreColorViewController.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 22.03.2025.
//

import UIKit

final class MoreColorViewController: UIViewController {
    
    private var moreColorView = MoreColorView()
    private var viewModel = MoreColorViewModel()
    private var colorCell = "colorCell"
    
    var isSelectedColor: IndexPath?
    var onNewSelectedColor: ((IndexPath) -> Void)?
    var newSelectedColor: ((IndexPath) -> Void)?
    
//    MARK: loadView
    override func loadView() {
        self.view = moreColorView
    }
    
//    MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        
        moreColorView.collectionView.delegate = self
        moreColorView.collectionView.dataSource = self
    }
    
//    MARK: setupButton
    private func setupButton() {
        moreColorView.closeVCButton.addTarget(self, action: #selector(closeVCButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeVCButtonTapped() {
        dismiss(animated: true)
    }
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MoreColorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    кол-во секций
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.section.count
    }
    
//    кол-во элементов в каждой секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.section[section].color.count
    }
    
//    создание ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moreColorView.collectionView.dequeueReusableCell(withReuseIdentifier: colorCell, for: indexPath) as! ColorCell
        let color = viewModel.section[indexPath.section].color[indexPath.row]
        let isSelect = indexPath == isSelectedColor
        cell.configure(with: color, isSilected: isSelect)
        return cell
    }

//    заголовок
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderReusableView
            
            header.labelHeadline.text = viewModel.section[indexPath.section].title
            return header
        }
        return UICollectionViewCell()
    }
    
//    выбираем изображение
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelectedColor = indexPath
        let selectedColor = viewModel.section[indexPath.section].color[indexPath.item]
        print("Выбранный индекс внутри массива moreColorView \(indexPath)")
        onNewSelectedColor?(indexPath)
        newSelectedColor?(indexPath)
        moreColorView.collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40) // высота заголовка
    }
}
