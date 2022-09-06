//
//  UIContentConfiguration+Stateless.swift
//  Today
//
//  Created by Sanghun Park on 05.09.22.
//

import UIKit

extension UIContentConfiguration {
    
    /// Allows a `UIContentConfiguration` to provide a specialized configuration for a given state.
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
