//
//  Color+Extensions.swift
//  ChoreTracker
//
//  Created by Nathan Fuller on 3/24/24.
//

import SwiftUI

extension Color {
    enum Background {
        static let page = Color(UIColor(resource: .Colors.Background.page))
        static let pageLight = Color(UIColor(resource: .Colors.Background.page))
        static let card = Color(UIColor(resource: .Colors.Background.card))
    }
    
    enum Icon {
        static let neutral = Color(UIColor(resource: .Colors.Icon.neutral))
        static let destructive = Color(UIColor(resource: .Colors.Icon.destructive))
    }
    
    enum Text {
        static let primary = Color(UIColor(resource: .Colors.Text.primary))
        static let secondary = Color(UIColor(resource: .Colors.Text.secondary))
    }
}
