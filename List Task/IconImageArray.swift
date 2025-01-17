//
//  IconImageArray.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 10.01.2025.
//

import UIKit

final class IconImageArray {
    
    static let shared = IconImageArray()
    
    let icons: [UIImage] = [
        UIImage(systemName: "figure.highintensity.intervaltraining")!,
        UIImage(systemName: "laptopcomputer.and.iphone")!,
        UIImage(systemName: "graduationcap")!,
        UIImage(systemName: "person")!,
        UIImage(systemName: "list.bullet.clipboard")!,
        UIImage(systemName: "star")!,
        UIImage(systemName: "heart")!,
        UIImage(systemName: "tag")!
    ]
    
    private init() {}
}
