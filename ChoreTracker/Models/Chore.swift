//
//  Chore.swift
//  ChoreTracker
//
//  Created by Nathan Fuller on 3/17/24.
//

import Foundation
import SwiftData

@Model
final class Chore: Comparable {
    var createdAt: Date
    var completedAt: Date?
    var title: String = ""
    
    init(title: String) {
        self.title = title
        self.createdAt = Date()
    }
    
    static func < (lhs: Chore, rhs: Chore) -> Bool {
        rhs.createdAt < lhs.createdAt
    }
    
    func complete(date: Date = Date()) {
        completedAt = date
    }
    
    func uncomplete() {
        completedAt = nil
    }
}
