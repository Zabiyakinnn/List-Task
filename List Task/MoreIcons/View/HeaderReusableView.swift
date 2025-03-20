//
//  HeaderReusableView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 14.03.2025.
//

import UIKit

final class HeaderReusableView: UICollectionReusableView {
    
    let labelHeadline: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont(name: "Bluecurve-Light", size: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(labelHeadline)
        
        NSLayoutConstraint.activate([
            labelHeadline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelHeadline.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
