//
//  ReminderViewController.swift
//  Today
//
//  Created by Sanghun Park on 15.08.22.
//

import UIKit

/// Lay out the list of reminder detailes and supplies the list with the reminder details data.
class ReminderViewController: UICollectionViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder {
        didSet {
            onChange(reminder)
        }
    }
    var workingReminder: Reminder   // temporary reminder that stores the edits until the user chooses to save or discard.
    var isAddingNewReminder = false
    var onChange: (Reminder)->Void
    private var dataSource: DataSource!
    
    init(reminder: Reminder, onChange: @escaping (Reminder)->Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChange = onChange
        
        // a list compositional layout contains only the layout information needed for a list
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        */
        // Do any additional setup after loading the view.
        
        // Create new cell registration
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        /// Lists in the app can potentially hold many more items than can fit onscreen. To avoid unnecessary cell creation, the system maintains a queue of collection cells to recycle after they go off screen.
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateSnapshotForViewing()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Methods
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            prepareForEditing()
        }
        else {
            if !isAddingNewReminder {
                prepareForViewing()
            }
            else {
                onChange(workingReminder)
            }
        }
    }
    
    /// Set the cell's content and appearance to support the view and editing modes.
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        
        // Retrieve the section from the index path
        let section = section(for: indexPath)
        
        // Add a switch statement to configure cells for different section and row combinations.
        switch (section, row) {
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, .editText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
        case (.date, .editDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        case (.notes, .editText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
        default:
            fatalError("Unexpected combination of section and row.")
        }
        
        cell.tintColor = .todayPrimaryTint
    }
    
    @objc func didCancelEdit() {
        // reset the working reminder
        workingReminder = reminder
        // make the button to show "Edit" again
        setEditing(false, animated: true)
    }
    
    private func prepareForEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        updateSnapShotForEditing()
    }
    
    private func updateSnapShotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, .notes])
        snapshot.appendItems([.header(Section.title.name), .editText(reminder.title)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editText(reminder.notes)], toSection: .notes)
        dataSource.apply(snapshot)
    }
    
    private func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        if workingReminder != reminder {
            reminder = workingReminder
        }
        updateSnapshotForViewing()
    }
    
    private func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        snapshot.appendItems([.header(""), .viewTitle, .viewDate, .viewTime, .viewNotes], toSection: .view)
        dataSource.apply(snapshot)
    }
    
    /// returns the section for a row to pass
    private func section(for indexPath: IndexPath) -> Section {
        
        /// In view mode, all items are displayed in section 0.
        /// In editing mode, the title, date, and notes are separated into sections 1, 2, and 3, respectively.
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        
        /// Swift enumerations defined with a raw value have a failable initializer that returns `nil` if the provided raw value is outside the defined range.
        guard let section = Section(rawValue: sectionNumber) else {  fatalError("Unable to find matching section") }
        
        return section
    }

    // MARK: UICollectionViewDataSource

    /*
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
