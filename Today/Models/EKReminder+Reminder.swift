//
//  EKReminder+Reminder.swift
//  Today
//
//  Created by Sanghun Park on 09.09.22.
//

import Foundation
import EventKit

extension EKReminder {
    
    func update(using reminder: Reminder, in store: EKEventStore) {
        self.title = reminder.title
        self.notes = reminder.notes
        self.isCompleted = reminder.isComplete
        self.calendar = store.defaultCalendarForNewReminders()
        self.alarms?.forEach { alarm in
            guard let absoluteDate = alarm.absoluteDate else { return }
            let comparison = Locale.current.calendar.compare(reminder.dueDate, to: absoluteDate, toGranularity: .minute)
            if comparison != .orderedSame {
                removeAlarm(alarm)
            }
        }
        if !hasAlarms {
            addAlarm(EKAlarm(absoluteDate: reminder.dueDate))
        }
    }
}
