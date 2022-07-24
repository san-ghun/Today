//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Sanghun Park on 24.07.22.
//

import UIKit

// Collection view data source manage the data in collection view. It create and configure the cells that the collection view uses to display items in list.
// The extension contain all the behaviors that let the `ReminderListViewController` act as a data source to the reminder list.
extension ReminderListViewController {
    
    // type alias difinitions for data source and snapshots of reminder data.
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    // Set the cell's content and appearance.
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: String) {
        
        let reminder = Reminder.sampleData[indexPath.item]
        
        // Configure content and appearance
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        // deemphasize the date and time to draw more attention to the title
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        // Apply the content configurateion to cell
        cell.contentConfiguration = contentConfiguration
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
}
