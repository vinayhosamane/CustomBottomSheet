//
//  CustomPresentationController.swift
//  CustomBottomSheet
//
//  Created by Hosamane, Vinay K N on 16/07/21.
//

import Foundation
import UIKit

class CustomPresentationController: UIPresentationController {
    
    lazy private var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy private var tapgesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedView(_:)))
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    
    // pan gesture
    lazy private var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(CustomPresentationController.viewDidPan(sender:)))
        gesture.maximumNumberOfTouches = 1
        gesture.minimumNumberOfTouches = 1
        
        gesture.delegate = self
        return gesture
    }()
    
    var longFormYPosition: CGFloat = 265
    
    private var anchoredYPosition: CGFloat = 65.0
    
    @objc
    func dismissPresentedView(_ sender: UITapGestureRecognizer) {
        // dismiss the modal
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        containerView?.isUserInteractionEnabled = true
        
        // change layout here
        guard let containerView = containerView,
              let presentedView = presentedView else {
            return
        }
        
        presentedView.clipsToBounds = true
        
        containerView.addSubview(blurView)
        containerView.addSubview(presentedView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
//        blurView.addGestureRecognizer(tapgesture)
//        containerView.addGestureRecognizer(tapgesture)
        
        blurView.addGestureRecognizer(panGesture)
        containerView.addGestureRecognizer(panGesture)
        
        // let's add content insets to presneted view
//        let inset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
//        presentedView.layoutMargins = inset
//
//        presentedView.frame = presentedView.frame.inset(by: inset)
        
        // let's add some corner radius to presented view
        let path = UIBezierPath(roundedRect: presentedView.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 10, height: 10))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        presentedView.layer.mask = mask

        // Improve performance by rasterizing the layer
        presentedView.layer.shouldRasterize = true
        presentedView.layer.rasterizationScale = UIScreen.main.scale
        
        // update height or y position of presentedView
        let adjustedSize = CGSize(width: containerView.frame.size.width, height: containerView.frame.size.height - longFormYPosition)
        presentedView.frame.origin.y = longFormYPosition
        //presentedViewController.view.frame = CGRect(origin: .zero, size: adjustedSize)
    }
    
    @objc
    func viewDidPan(sender: UIPanGestureRecognizer) {
        guard let containerView = containerView else {
            sender.setTranslation(.zero, in: sender.view)
            return
        }
        
        switch sender.state {
        case .began, .changed:

            guard let presentedView = presentedView else {
                return
            }
            
            let currentY =  presentedView.frame.origin.y
            let yDisplacement = sender.translation(in: containerView).y
            
            print(yDisplacement)
            
            if presentedView.frame.origin.y < 0 {
               //yDisplacement = yDisplacement
            }
            
            print("origin y -- \(presentedView.frame.origin.y)")
            
//            if presentedView.frame.origin.y < 110.0 {
//                presentedView.frame.origin.y = currentY + yDisplacement
//            }
            
//            if currentY < 50.0 {
//                return
//            }
            
            if currentY > 600.0 {
                presentedViewController.dismiss(animated: true, completion: nil)
            }
            
            sender.setTranslation(.zero, in: presentedView)
////
            presentedView.frame.origin.y = currentY + yDisplacement
            
            //sender.setTranslation(.zero, in: presentedView)
            
//            /**
//             Respond accordingly to pan gesture translation
//             */
//            respond(to: recognizer)
//
//            /**
//             If presentedView is translated above the longForm threshold, treat as transition
//             */
//            if presentedView.frame.origin.y == anchoredYPosition && extendsPanScrolling {
//                presentable?.willTransition(to: .longForm)
//            }

        default: break

            /**
             Use velocity sensitivity value to restrict snapping
             */
            //let velocity = sender.velocity(in: containerView)
        }
    }
    
    func respond(to panGestureRecognizer: UIPanGestureRecognizer) {
        guard let presentedView = presentedView else {
            return
        }

        var yDisplacement = panGestureRecognizer.translation(in: presentedView).y

        /**
         If the presentedView is not anchored to long form, reduce the rate of movement
         above the threshold
         */
        if presentedView.frame.origin.y < longFormYPosition {
            yDisplacement /= 2.0
        }
        adjust(toYPosition: presentedView.frame.origin.y + yDisplacement)

        panGestureRecognizer.setTranslation(.zero, in: presentedView)
    }
    
    func adjust(toYPosition yPos: CGFloat) {
        guard let presentedView = presentedView else {
            return
        }

        presentedView.frame.origin.y = max(yPos, anchoredYPosition)
        
//        guard presentedView.frame.origin.y > longFormYPosition else {
//            backgroundView.dimState = .max
//            return
//        }
//
//        let yDisplacementFromShortForm = presentedView.frame.origin.y - shortFormYPosition

        /**
         Once presentedView is translated below shortForm, calculate yPos relative to bottom of screen
         and apply percentage to backgroundView alpha
         */
        //backgroundView.dimState = .percent(1.0 - (yDisplacementFromShortForm / presentedView.frame.height))
    }

    
}

extension CustomPresentationController: UIGestureRecognizerDelegate {

    /**
     Do not require any other gesture recognizers to fail
     */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    /**
     Allow simultaneous gesture recognizers only when the other gesture recognizer's view
     is the pan scrollable view
     */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


class CustomPresenttaionTransitionDelegate: NSObject {
    
    static var `default`: CustomPresenttaionTransitionDelegate = {
       return CustomPresenttaionTransitionDelegate()
    }()
    
}


extension CustomPresenttaionTransitionDelegate: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = CustomPresentationController(presentedViewController: presented, presenting: presenting)
        return controller
    }
    
}
