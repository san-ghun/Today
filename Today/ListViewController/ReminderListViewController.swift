//
//  ViewController.swift
//  Today
//
//  Created by Sanghun Park on 23.07.22.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
    // Diffable data source
    // SHOULD initialize the data source with guarantee that the optional has a value
    var dataSource: DataSource!
    
    // reminders property to configure snapshots and collection view cells. Init with sample data.
    var reminders: [Reminder] = Reminder.sampleData
    
    var filteredReminders: [Reminder] {
        return reminders
            .filter { listStyle.shouldInclude(date: $0.dueDate) }
            .sorted { $0.dueDate < $1.dueDate }
    }
    var listStyle: ReminderListStyle = .today
    let listStyleSegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name
    ])
    var headerView: ProgressHeaderView?
    var progress: CGFloat {
        let chunkSize = 1.0 / CGFloat(filteredReminders.count)
        let progress = filteredReminders.reduce(0.0) {
            let chunk = $1.isComplete ? chunkSize : 0
            return $0 + chunk
        }
        return progress
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.backgroundColor = .todayGradientFutureBegin
        
        // Configure the collection view appearance as a list, using compositional layout.
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        // Set the cell's content and appearance.
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // Connect the diffable data source to the collection view by passing in the collection view to the diffable data source initializer.
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        // Register the header view as a supplementary view.
        let headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: ProgressHeaderView.elementKind, handler: supplementaryRegistrationHandler)
        dataSource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        // Set a button which add new reminder
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton
        
        // Set segmented control
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl
        
        // Update snapshot
        updateSnapshot()
        
        // Assign the data source to the collection view.
        collectionView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBackground()
    }
    
    // Not showing the item that the user tapped as selected.
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let id = filteredReminders[indexPath.item].id
        showDetail(for: id)
        return false
    }
    
    // Called when the collection view is about to display the supplementary view.
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        // Triggers the header view's `didSet` observer.
        guard elementKind == ProgressHeaderView.elementKind, let progressView = view as? ProgressHeaderView else { return }
        progressView.progress = progress
    }
    
    func refreshBackground() {
        collectionView.backgroundView = nil
        let backgroundView = UIView()
        let gradientLayer = CAGradientLayer.gradientLayer(for: listStyle, in: collectionView.frame)
        backgroundView.layer.addSublayer(gradientLayer)
        collectionView.backgroundView = backgroundView
    }
    
    func showDetail(for id: Reminder.ID) {
        let reminder = reminder(for: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.update(reminder, with: reminder.id)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showError(_ error: Error) {
        let alertTitle = NSLocalizedString("Error", comment: "Error alert title")
        let alert = UIAlertController(title: alertTitle, message: error.localizedDescription, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("OK", comment: "Alert OK button title")
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        
        // Create a section in a list layout
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
        listConfiguration.showsSeparators = false
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.deleteReminder(with: id)
            self?.updateSnapshot()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func supplementaryRegistrationHandler(progressView: ProgressHeaderView, elementKind: String, indexPath: IndexPath) {
        headerView = progressView
    }

}

