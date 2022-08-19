//
//  ReminderViewController+Row.swift
//  Today
//
//  Created by Sanghun Park on 18.08.22.
//

import UIKit

extension ReminderViewController {
    
    /// Use instances of Row to represent items in the detail list.
    /// Diffable data sources that supply UIKit lists with data and styling require that items conform to Hashable.
    /// The diffable data source uses the hash values to determine what changed between two snapshots of the data.
    enum Row: Hashable {
        case viewDate
        case viewNotes
        case viewTime
        case viewTitle
        
        var imageName: String? {
            switch self {
            case .viewDate:
                return "calendar.circle"
            case .viewNotes:
                return "square.and.pencil"
            case .viewTime:
                return "clock"
            default:
                return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .viewTitle: return .headline
            default: return .subheadline
            }
        }
    }
}
