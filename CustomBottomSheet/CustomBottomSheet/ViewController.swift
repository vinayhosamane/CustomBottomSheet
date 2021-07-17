//
//  ViewController.swift
//  CustomBottomSheet
//
//  Created by Hosamane, Vinay K N on 16/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    lazy private var button: UIButton = {
        let butttn = UIButton(type: .roundedRect)
        butttn.setTitle("Present", for: .normal)
        butttn.addTarget(nil, action: #selector(ViewController.buttontapped(_:)), for: .touchUpInside)
        butttn.translatesAutoresizingMaskIntoConstraints = false
        return butttn
    }()
    
    lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy private var tapgesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissPresentedView(sender:)))
        gesture.numberOfTapsRequired = 1
        gesture.delegate = self
        return gesture
    }()
    
    lazy var handleBar: UIView = {
        let handle = UIView()
        handle.backgroundColor = UIColor.gray
        
        handle.layer.masksToBounds = true
        handle.layer.cornerRadius = 5.0
        
        handle.translatesAutoresizingMaskIntoConstraints = false
        return handle
    }()
    
    var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.didPanView(sender:)))
        //gesture.delegate = self
        return gesture
    }()
    
    var customToastView: UIView = {
        let toastView = CustomToastView()
        return toastView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        
        // add button
        view.addSubview(button)
        
        // add tap gesture
        blurView.addGestureRecognizer(tapgesture)
        
//        blurView.hitTest(<#T##point: CGPoint##CGPoint#>, with: nil)
        
        // add auto layout to button
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // let's add bottom sheet view below the content view
        view.addSubview(bottomSheetView)
        
//        NSLayoutConstraint.activate([
//            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomSheetView.topAnchor.constraint(equalTo: view.topAnchor),
//            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
        
        bottomSheetView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
        
        // let's add some corner radius to presented view
        let path = UIBezierPath(roundedRect: bottomSheetView.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        bottomSheetView.layer.mask = mask

        // Improve performance by rasterizing the layer
        bottomSheetView.layer.shouldRasterize = true
        bottomSheetView.layer.rasterizationScale = UIScreen.main.scale
        
        bottomSheetView.layer.shadowColor = UIColor.black.cgColor
        bottomSheetView.layer.shadowRadius = 5
        bottomSheetView.layer.shadowOpacity = 0.7
        
        bottomSheetView.addGestureRecognizer(panGesture)
        
        // let's add handle bar to bottom sheet
        //bottomSheetView.addSubview(handleBar)
        
        view.addSubview(customToastView)
        
        let layoutMarginFrame = self.view.safeAreaLayoutGuide.layoutFrame
        customToastView.frame = CGRect(x: 0, y: view.frame.height, width: view.bounds.width, height: 100).inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // add constraints to handle bar
        // add auto layout to handle bar
//        NSLayoutConstraint.activate([
//            handleBar.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
//            handleBar.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 10),
//            handleBar.widthAnchor.constraint(equalToConstant: 50),
//            handleBar.heightAnchor.constraint(equalToConstant: 5)
//        ])
        
        // add handle bar
        bottomSheetView.addSubview(handleBar)
        handleBar.frame = CGRect(x: view.frame.width / 2 - 25, y: 10, width: 50, height: 5)
        
       
    }

    @objc
    func buttontapped(_ sender: UIButton) {
        let baseViewController = BaseViewController()
        baseViewController.modalPresentationStyle = .custom
        baseViewController.transitioningDelegate = CustomPresenttaionTransitionDelegate.default
        present(baseViewController, animated: true, completion: nil)
//        UIView.animate(withDuration: 1,
//                       delay: 0,
//                       usingSpringWithDamping: 1,
//                       initialSpringVelocity: 1,
//                       options: .curveEaseInOut) {
//            // add blurview to the back
//            self.view.insertSubview(self.blurView, at: 0)
//
//            // animate the bottom sheet to gain size of half the height of container view
//            self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height / 2)
//        }
        
        // Show toast message
        //showToastMessage(show: true)
    }
    
    func showToastMessage(show: Bool) {
        if show {
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseInOut) {
                let layoutMarginFrame = self.view.safeAreaLayoutGuide.layoutFrame
                self.customToastView.frame = CGRect(x: 0, y: self.view.frame.height - layoutMarginFrame.minY - 60, width: self.view.bounds.width, height: 100).inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
            }

        }
    }
    
    @objc
    func dismissPresentedView(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 2,
                       delay: 1,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut) {
            // add blurview to the back
            self.blurView.removeFromSuperview()
            
            // animate the bottom sheet to gain size of half the height of container view
            self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }
    }
    
    @objc
    func didPanView(sender: UIPanGestureRecognizer) {
        
    }

}

extension ViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    
}

