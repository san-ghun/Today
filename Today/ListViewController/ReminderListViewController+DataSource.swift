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
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    // accessibilityValue, using computed properties, for the button
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    /// Update and apply a snapshot to update user interface when data changes.
    func updateSnapshot(reloading idsThatChanged: [Reminder.ID] = []) {
        // Sepcifying an empty array as the default value for the parameter lets the app call the method from `viewDidLoad()` without providing identifiers.
        
        // Filter IDs to include only id that correspond to reminders in the filteredReminders array
        let ids = idsThatChanged.filter { id in 
            filteredReminders.contains(where: { $0.id == id })
        }
        
        // Create an empty snapshot, and append sections and items.
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map { $0.id })
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        
        // Apply the snapshot to the data source
        dataSource.apply(snapshot)
        
        // Update the header view's progress
        headerView?.progress = progress
    }
    
    // Set the cell's content and appearance.
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        
        let reminder = reminder(for: id)
        
        // Configure content and appearance
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        // deemphasize the date and time to draw more attention to the title
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        // Apply the content configurateion to cell
        cell.contentConfiguration = contentConfiguration
        
        // Call and assign done button configuration method
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        
        // Set the cell's `accessibilityCustomActions` array to an instance of the custom action.
        cell.accessibilityCustomActions = [ doneButtonAccessibilityAction(for: reminder) ]
        
        // Assign the correct localized string to the cell's accessibilityValue.
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        
        // Create an array of cell accessories, and assign the button configuration
        cell.accessories = [ .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always) ]
        
        // Apply background configuration for cell
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    func completeReminder(with id: Reminder.ID) {
        
        // Fetch the reminder
        var reminder = reminder(for: id)
        
        // Toggle the isComplete property
        reminder.isComplete.toggle()
        
        // Update the reminder
        update(reminder, with: id)
        
        // Update snapshot to update UI
        updateSnapshot(reloading: [id])
    }
    
    // Call the method in the cell registration handler to create a custom action for each cell.
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        
        // By default, closures create a strong reference to external values that use inside them. Specifying a `weak` reference to the view controller prevents a retain cycle.
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(with: reminder.id)
            return true
        }
        return action
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        
        // Ternary conditional operator to assign circle.fill or circle
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.id = reminder.id
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    func add(_ reminder: Reminder) {
        reminders.append(reminder)
    }
    
    func deleteReminder(with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders.remove(at: index)
    }
    
    func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    func update(_ reminder: Reminder, with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders[index] = reminder
    }
}
