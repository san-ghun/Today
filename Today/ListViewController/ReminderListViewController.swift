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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Configure the collection view appearance as a list, using compositional layout.
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        // Set the cell's content and appearance.
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // Connect the diffable data source to the collection view by passing in the collection view to the diffable data source initializer.
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        updateSnapshot()
        
        // Assign the data source to the collection view.
        collectionView.dataSource = dataSource
    }
    
    // Not showing the item that the user tapped as selected.
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let id = reminders[indexPath.item].id
        showDetail(for: id)
        return false
    }
    
    func showDetail(for id: Reminder.ID) {
        let reminder = reminder(for: id)
        let viewController = ReminderViewController(reminder: reminder)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        
        // Create a section in a list layout
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

}

