//
//  EKEventStore+AsyncFetch.swift
//  Today
//
//  Created by Sanghun Park on 08.09.22.
//

import Foundation
import EventKit

extension EKEventStore {
    
    func fetchReminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        
        try await withCheckedThrowingContinuation { continuation in
            fetchReminders(matching: predicate) { reminders in
                if let reminders = reminders {
                    continuation.resume(returning: reminders)
                }
                else {
                    continuation.resume(throwing: TodayError.failedReadingReminders)
                }
            }
        }
    }
}
