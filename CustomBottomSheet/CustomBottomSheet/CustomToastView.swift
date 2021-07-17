//
//  CustomToastView.swift
//  CustomBottomSheet
//
//  Created by Hosamane, Vinay K N on 16/07/21.
//

import Foundation
import UIKit

class CustomToastView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = UIColor.yellow
        
        clipsToBounds = true
        // corner radius
        layer.cornerRadius = 30
        
        //label
        let label = UILabel()
        label.text = "This is a toast Message. All dependencies are downloaded Successfully."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
//        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
//        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
}
