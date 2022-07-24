//
//  ViewController.swift
//  Today
//
//  Created by Sanghun Park on 23.07.22.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
    var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Configure the collection view appearance as a list, using compositional layout.
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        // Set the cell's content and appearance.
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // Connect the diffable data source to the collection view by passing in the collection view to the diffable data source initializer.
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        // Create an empty snapshot, and append sections and items.
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map { $0.title })
        
        // Apply the snapshot to the data source
        dataSource.apply(snapshot)
        
        // Assign the data source to the collection view.
        collectionView.dataSource = dataSource
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        
        // Create a section in a list layout
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

}

