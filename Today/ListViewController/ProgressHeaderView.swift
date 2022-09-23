//
//  ProgressHeaderView.swift
//  Today
//
//  Created by Sanghun Park on 08.09.22.
//

import UIKit

class ProgressHeaderView: UICollectionReusableView {
    static var elementKind: String { UICollectionView.elementKindSectionHeader }
    
    var progress: CGFloat = 0 {
        didSet {
            waveView.setupProgress(progress)
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private var waveView: WaveAnimationView!
    private var heightConstraint: NSLayoutConstraint?
    private var valueFormat: String { NSLocalizedString("%d percent", comment: "progress percentage value format") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        waveView = WaveAnimationView(frame: CGRect(origin: .zero, size: bounds.size))
        prepareSubviews()
        waveView.setupProgress(waveView.progress)
        
        isAccessibilityElement = true
        accessibilityLabel = NSLocalizedString("Progress", comment: "Progress view accessibility label")
        accessibilityTraits.update(with: .updatesFrequently)
    }
    
    required init?(coder: NSCoder) {
        fatalError("ProgressHeaderView - init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accessibilityValue = String(format: valueFormat, Int(progress * 100.0))
        
        // customize the view's layout behavior to adjust the corner radius whenever the size changes
        
        // Core Animation applies a clipping mast to the CGRect frame that shapes the container view into a circle
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 0.5 * containerView.bounds.width
    }
    
    private func prepareSubviews() {
        
        // add view to the view hierarchy
        containerView.addSubview(waveView)
        addSubview(containerView)
        
        // disable auto-resizing by system
        waveView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // set constraints for views,
        // maintain 1:1 fixed aspect ratio for superview and container views
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        
        // center the container view herizontally and vertically in the layout frame
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        waveView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        waveView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        // scale the container view to 85 percent of the size of its superview.
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        
        // vertically constraint the subviews
        waveView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        waveView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // horizontally constrain the subviews
        waveView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        waveView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        // assign background colors to the views
        backgroundColor = .clear
        containerView.backgroundColor = .clear
    }
}
