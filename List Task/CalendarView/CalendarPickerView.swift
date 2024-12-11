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
}
