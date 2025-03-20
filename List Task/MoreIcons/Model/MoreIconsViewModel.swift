//
//  MoreIconsViewModel.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 14.03.2025.
//

import UIKit

struct IconSection {
    let title: String
    let icons: [UIImage]
}

final class MoreIconsViewModel {
    
    var section: [IconSection] = [
        IconSection(title: "Основные",
                    icons: [UIImage(systemName: "person")!,
                            UIImage(systemName: "figure.highintensity.intervaltraining")!,
                            UIImage(systemName: "graduationcap")!,
                            UIImage(systemName: "heart")!,
                            UIImage(systemName: "tag")!]),
        IconSection(title: "Развлечения",
                    icons: [UIImage(systemName: "book")!,
                            UIImage(systemName: "music.mic")!,
                            UIImage(systemName: "beats.headphones")!,
                            UIImage(systemName: "gamecontroller")!,
                            UIImage(systemName: "circle.square")!]),
        IconSection(title: "Работа",
                    icons: [UIImage(systemName: "list.clipboard")!,
                            UIImage(systemName: "envelope")!,
                            UIImage(systemName: "doc")!,
                            UIImage(systemName: "pencil")!,
                            UIImage(systemName: "folder")!]),
        IconSection(title: "Спорт",
                    icons: [UIImage(systemName: "volleyball")!,
                            UIImage(systemName: "hockey.puck")!,
                            UIImage(systemName: "basketball")!,
                            UIImage(systemName: "dumbbell")!,
                            UIImage(systemName: "trophy")!]),
        IconSection(title: "Медиа",
                    icons: [UIImage(systemName: "mic")!,
                            UIImage(systemName: "message.badge")!,
                            UIImage(systemName: "video")!,
                            UIImage(systemName: "camera")!,
                            UIImage(systemName: "photo")!]),
        IconSection(title: "Здоровье",
                    icons: [UIImage(systemName: "medical.thermometer")!,
                            UIImage(systemName: "heart")!,
                            UIImage(systemName: "cross.case")!,
                            UIImage(systemName: "pills")!,
                            UIImage(systemName: "cross")!]),
        IconSection(title: "Путешествия",
                    icons: [UIImage(systemName: "airplane")!,
                            UIImage(systemName: "map")!,
                            UIImage(systemName: "car")!,
                            UIImage(systemName: "bus.fill")!,
                            UIImage(systemName: "tram")!])
    ]
}
