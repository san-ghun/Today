//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Sanghun Park on 25.07.22.
//

import UIKit

extension ReminderListViewController {
    
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(with: id)
    }
}
