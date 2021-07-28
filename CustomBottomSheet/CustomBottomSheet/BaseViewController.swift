//
//  BaseViewController.swift
//  CustomBottomSheet
//
//  Created by Hosamane, Vinay K N on 16/07/21.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    lazy var handleBar: UIView = {
        let handle = UIView()
        handle.backgroundColor = UIColor.gray
        
        handle.layer.masksToBounds = true
        handle.layer.cornerRadius = 5.0
        
        handle.translatesAutoresizingMaskIntoConstraints = false
        return handle
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.yellow.withAlphaComponent(0.6)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addCustomView()
    }
    
    func addCustomView() {
        view.addSubview(handleBar)
        
        NSLayoutConstraint.activate([
            handleBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handleBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            handleBar.widthAnchor.constraint(equalToConstant: 50),
            handleBar.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
}
