//
//  SGMarkerView.swift
//  iSolarCloudDBO
//
//  Created by kjlink on 2016/12/7.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

public class SGMarkerView: UIView {
    
    private let TotalRowCount = 5
    
    fileprivate lazy var topConstraint: NSLayoutConstraint? = {
        guard let superV = self.superview else {
            return nil;
        }
        return self.topAnchor.constraint(equalTo: superV.topAnchor, constant: 0)
    }()
    
    fileprivate lazy var leadingConstraint: NSLayoutConstraint? = {
        guard let superV = self.superview else {
            return nil;
        }
        return self.leadingAnchor.constraint(equalTo: superV.leadingAnchor, constant: 0)
    }()
    
    fileprivate lazy var stackView: UIStackView = {
        let stakcV = UIStackView()
        stakcV.axis = .vertical
        stakcV.spacing = 2
        stakcV.alignment = .leading
        stakcV.distribution = .equalSpacing
        return stakcV
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        for _ in 0..<5 {
            let label = UILabel()
            label.textColor = UIColor.white
            label.numberOfLines = 0;
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 12)
            stackView.addArrangedSubview(label)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superV = superview else {
            return;
        }
        widthAnchor.constraint(lessThanOrEqualTo: superV.widthAnchor, multiplier: 1, constant: -16).isActive = true
        
        leftAnchor.constraint(greaterThanOrEqualTo: superV.leftAnchor, constant: 8).isActive = true
        rightAnchor.constraint(lessThanOrEqualTo: superV.rightAnchor, constant: -8).isActive = true
        topConstraint?.isActive = true
        leadingConstraint?.isActive = true
        
        topConstraint?.priority = .defaultLow
        leadingConstraint?.priority = .defaultLow
    }
    
    @objc open func refreshContent(positon: CGPoint, content: [String]) {
        for index in 0..<TotalRowCount {
            var text: String?
            if index < content.count {
                text = content[index]
            }
            if let label = stackView.arrangedSubviews[index] as? UILabel {
                label.text = text
            }
        }
        
        var finalOrigin = self.frame.origin;
        let superViewW = self.superview?.frame.width ?? 0
        let superViewH = self.superview?.frame.height ?? 0
        
        finalOrigin.x = positon.x > superViewW * 0.5 ? positon.x - self.frame.width : positon.x
        finalOrigin.y = (superViewH - positon.y - 24) > self.frame.height ? positon.y : superViewH - self.frame.height - 24
        
        topConstraint?.constant = finalOrigin.y
        leadingConstraint?.constant = finalOrigin.x
        
        UIView.animate(withDuration: 0.25) {
            self.superview?.layoutIfNeeded()
        }
    }
}
