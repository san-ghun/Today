//
//  ReminderViewController+Section.swift
//  Today
//
//  Created by Sanghun Park on 22.08.22.
//

import UIKit

/// Contain the code to represent collection view sections.
extension ReminderViewController {
    
    /// Section and item identifier types must conform to `Hashable` because the data source uses hash values to determine changes in data.
    /// The data source supplies information in a single view section if the user views the details of a reminder. It supplies data in three separate sections if the user is editing a reminder because each item has an iindividual control.
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case notes
        
        var name: String {
            switch self {
            case .view: return ""
            case .title:
                return NSLocalizedString("Title", comment: "Title section name")
            case .date:
                return NSLocalizedString("Date", comment: "Date section name")
            case .notes:
                return NSLocalizedString("Notes", comment: "Notes section name")
            }
        }
    }
}
