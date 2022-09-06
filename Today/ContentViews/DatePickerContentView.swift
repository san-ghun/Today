//
//  DatePickerContentView.swift
//  Today
//
//  Created by Sanghun Park on 05.09.22.
//

import UIKit

class DatePickerContentView: UIView, UIContentView {
    
    /// To customize the content of the configuration and the view.
    struct Configuration: UIContentConfiguration {
        var date = Date.now
        var onChange: (Date)->Void = { _ in }
        
        /// The final behavior that need to include to conform to the `UIContentConfiguration` protocol.
        func makeContentView() -> UIView & UIContentView {
            return DatePickerContentView(self)
        }
    }
    
    let datePicker = UIDatePicker()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubView(datePicker)
        datePicker.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .inline
    }
    
    required init?(coder: NSCoder) {
        fatalError("DatePickerContentView - init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        datePicker.date = configuration.date
    }
    
    @objc private func didPick(_ sender: UIDatePicker) {
        guard let configuration = configuration as? DatePickerContentView.Configuration else { return }
        configuration.onChange(sender.date)
    }
}

/// Extension to return a custom configuration that will pair with the custom `DatePickerContentView`.
extension UICollectionViewListCell {
    
    /// Returns a new `DatePickerContentView.Configuration`.
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
