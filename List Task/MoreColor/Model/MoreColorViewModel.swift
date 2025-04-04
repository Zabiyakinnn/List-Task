//
//  MoreColorViewModel.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 22.03.2025.
//

import UIKit

struct ColorSection {
    let title: String
    let color: [UIColor]
}

final class MoreColorViewModel {
    var section: [ColorSection] = [
        ColorSection(title: "Основные",
                     color: [UIColor(red: 0.31, green: 0.38, blue: 0.50, alpha: 1.00),
                             UIColor(red: 0.29, green: 0.47, blue: 0.46, alpha: 1.00),
                             UIColor(red: 0.54, green: 0.60, blue: 0.52, alpha: 1.00),
                             UIColor(red: 0.65, green: 0.27, blue: 0.20, alpha: 1.00),
                             UIColor(red: 0.73, green: 0.84, blue: 0.85, alpha: 1.00)
                            ]),
        ColorSection(title: "Дополнительные",
                     color: [UIColor(red: 1.00, green: 0.95, blue: 0.53, alpha: 1.00),
                             UIColor(red: 0.62, green: 0.87, blue: 1.00, alpha: 1.00),
                             UIColor(red: 0.81, green: 0.07, blue: 0.29, alpha: 1.00),
                             UIColor(red: 0.01, green: 0.26, blue: 0.34, alpha: 1.00),
                             UIColor(red: 0.00, green: 0.40, blue: 1.00, alpha: 1.00)
                            ]),
        ColorSection(title: "Фоновые",
                     color: [UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00),
                             UIColor(red: 0.96, green: 0.94, blue: 0.88, alpha: 1.00),
                             UIColor(red: 1.00, green: 1.00, blue: 0.94, alpha: 1.00),
                             UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00),
                             UIColor(red: 0.70, green: 0.74, blue: 0.80, alpha: 1.00)
                            ]),
        ColorSection(title: "Теплые",
                     color: [UIColor(red: 1.00, green: 0.80, blue: 0.64, alpha: 1.00),
                             UIColor(red: 1.00, green: 0.55, blue: 0.20, alpha: 1.00),
                             UIColor(red: 0.94, green: 0.80, blue: 0.60, alpha: 1.00),
                             UIColor(red: 0.72, green: 0.25, blue: 0.15, alpha: 1.00),
                             UIColor(red: 0.89, green: 0.66, blue: 0.16, alpha: 1.00)
                            ]),
        ColorSection(title: "Холодные",
                     color: [UIColor(red: 0.80, green: 0.92, blue: 1.00, alpha: 1.00),
                             UIColor(red: 0.10, green: 0.25, blue: 0.60, alpha: 1.00),
                             UIColor(red: 0.00, green: 0.50, blue: 0.50, alpha: 1.00),
                             UIColor(red: 0.29, green: 0.00, blue: 0.51, alpha: 1.00),
                             UIColor(red: 0.60, green: 0.65, blue: 0.70, alpha: 1.00)
                            ]),
        ColorSection(title: "Футуристические",
                     color: [UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00),
                             UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00),
                             UIColor(red: 0.00, green: 1.00, blue: 0.30, alpha: 1.00),
                             UIColor(red: 0.50, green: 0.00, blue: 0.80, alpha: 1.00),
                             UIColor(red: 1.00, green: 1.00, blue: 0.20, alpha: 1.00)
                            ])
    ]
        
}
