//
//  TextFieldContentView.swift
//  Today
//
//  Created by Sanghun Park on 03.09.22.
//

import UIKit

class TextFieldContentView: UIView, UIContentView {
    
    /// To customize the content of the configuration and the view.
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        
        /// The final behavior that need to include to conform to the `UIContentConfiguration` protocol.
        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(self)
        }
    }
    
    let textField = UITextField()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    /// To fix the height at 44 points, the minimum size for an accessible control.
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubView(textField, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textField.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("TextFieldContentView - init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textField.text = configuration.text
    }
}

/// Extension to return a custom configuration that will pair with the custom `TextFieldContentView`.
extension UICollectionViewListCell {
    
    /// Returns a new `TextFieldContentView.Configuration`.
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}
