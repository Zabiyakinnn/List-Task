//
//  CalendarPickerView.swift
//  List Task
//
//  Created by Дмитрий Забиякин on 11.12.2024.
//

import UIKit
import SnapKit
import FSCalendar

final class CalendarPickerView: UIView {
    
    let calendar = FSCalendar()
    private let animationDuration = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCalendar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    настройка календаря
    private func setupCalendar() {
        backgroundColor = UIColor(named: "ColorCalendar")
        layer.cornerRadius = 20
        
        calendar.scrollDirection = .horizontal
        calendar.appearance.headerDateFormat = "LLLL"
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.firstWeekday = 2
        calendar.appearance.titleDefaultColor = UIColor(named: "ColorTextBlackAndWhite")
        calendar.appearance.weekdayTextColor = UIColor(named: "ColorTextBlackAndWhite")
        calendar.appearance.titleSelectionColor = UIColor(named: "SelectedDateCalendarColor")
        calendar.appearance.headerTitleColor = UIColor(named: "ColorTextBlackAndWhite")
        calendar.layer.cornerRadius = 20
        
        addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

    }
    
//    MARK: - Анимация открытия
    func show(in parentView: UIView) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / 2)
        parentView.addSubview(self)
        
        self.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 2)
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 1
            self.transform = .identity
        })
    }
    
//    MARK: - Анимация закрытия
    func hide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / 2)
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
}
