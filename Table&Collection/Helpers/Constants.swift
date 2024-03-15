//
//  Constants.swift
//  Table&Collection
//
//  Created by Vitaly Anpilov on 13.03.2024.
//

import UIKit

enum Constants {
    struct Cell {
        static let sideCell = UIScreen.main.bounds.size.height / 16
        static let borderWidth = 1.0
        static let cornerRadius = 8
        static let amountScale = 0.8
        static let animationDiration = 0.3
    }
    
    struct Table {
        static let rowHeight = UIScreen.main.bounds.size.height / 10
        static let inset: CGFloat = 16
    }
    
    // time
    static let timerInterval = 1
}
