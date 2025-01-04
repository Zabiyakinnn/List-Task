//
//  ColorCell.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 04.01.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 28.5
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(colorView)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    func configure(with color: UIColor, isSilected: Bool) {
        colorView.backgroundColor = color
//        рамка
        colorView.layer.borderWidth = isSilected ? 3 : 0
        colorView.layer.borderColor = isSilected ? UIColor.black.cgColor : nil
    }
}
