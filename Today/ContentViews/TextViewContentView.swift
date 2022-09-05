//
//  TextViewContentView.swift
//  Today
//
//  Created by Sanghun Park on 05.09.22.
//

import UIKit

class TextViewContentView: UIView, UIContentView {
    
    /// To customize the content of the configuration and the view.
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        
        /// The final behavior that need to include to conform to the `UIContentConfiguration` protocol.
        func makeContentView() -> UIView & UIContentView {
            return TextViewContentView(self)
        }
    }
    
    let textView = UITextView()
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
        addPinnedSubView(textView, height: 200)
        textView.backgroundColor = nil
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    required init?(coder: NSCoder) {
        fatalError("TextViewContentView - init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textView.text = configuration.text
    }
}

/// Extension to return a custom configuration that will pair with the custom `TextViewContentView`.
extension UICollectionViewListCell {
    
    /// Returns a new `TextViewContentView.Configuration`.
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}
