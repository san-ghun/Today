//
//  Reminder+EKReminder.swift
//  Today
//
//  Created by Sanghun Park on 08.09.22.
//

import Foundation
import EventKit

extension Reminder {
    
    init(with ekReminder: EKReminder) throws {
        
        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else {
            throw TodayError.reminderHasNoDueDate
        }
        
        self.id = ekReminder.calendarItemIdentifier
        self.title = ekReminder.title
        self.dueDate = dueDate
        self.notes = ekReminder.notes
        self.isComplete = ekReminder.isCompleted
    }
}
