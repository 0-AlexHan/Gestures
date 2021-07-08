//
//  ViewController.swift
//  Gestures
//
//  Created by Alex Han on 08.07.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var blueView: UIView!
    @IBOutlet private weak var centerXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var centerYConstraint: NSLayoutConstraint!
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var panGestureAnchorPoint: CGPoint?

    private let pinchGestureRecognizer = UIPinchGestureRecognizer()
    private var pinchGestureAnchorScale: CGFloat?

    private let rotationGestureRecognizer = UIRotationGestureRecognizer()
    private var rotationGestureAnchor: CGFloat?

    private let singleTapGestureRecognizer = UITapGestureRecognizer()
    
    private let resetTapGestureRecognizer = UITapGestureRecognizer()

    private let colorsOfView: [UIColor] = [#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]
    
    private var scale: CGFloat = 1 {
        didSet {
            blueView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale).rotated(by: rotate)
        }
    }
    private var rotate: CGFloat = 0 {
        didSet {
            blueView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale).rotated(by: rotate)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupPanGestureRecognizer()
        setupPinchGestureRecognizer()
        setupRotationGestureRecognizer()
        setupSingleTapGestureRecognizer()
        setupResetViewPositionTapGestureRecognizer()
    }
    

    private func setupPanGestureRecognizer() {
        panGestureRecognizer.delegate = self
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
        panGestureRecognizer.maximumNumberOfTouches = 1
        blueView.addGestureRecognizer(panGestureRecognizer)
    }

     private func setupPinchGestureRecognizer() {
        pinchGestureRecognizer.delegate = self
        pinchGestureRecognizer.addTarget(self, action: #selector(handlePinchGesture))
        blueView.addGestureRecognizer(pinchGestureRecognizer)
    }
     private func setupRotationGestureRecognizer() {
        rotationGestureRecognizer.delegate = self
        rotationGestureRecognizer.addTarget(self, action:#selector (handleRotationGesture))
        blueView.addGestureRecognizer(rotationGestureRecognizer)
    }

     private func setupSingleTapGestureRecognizer() {
        singleTapGestureRecognizer.delegate = self
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.addTarget(self, action: #selector(handleSingleTapGesture))
        blueView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func setupResetViewPositionTapGestureRecognizer() {
        resetTapGestureRecognizer.delegate = self
        resetTapGestureRecognizer.numberOfTapsRequired = 1
        resetTapGestureRecognizer.addTarget(self, action: #selector(handleResetViewPositionGesture))
        view.addGestureRecognizer(resetTapGestureRecognizer)
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard panGestureRecognizer === panGestureRecognizer else {
            return
        }

        switch gestureRecognizer.state {
            case .began:
                panGestureAnchorPoint = gestureRecognizer.location(in: view)
            case .changed:
                guard let panGestureAnchorPoint = panGestureAnchorPoint else {
                    return
                }

                let gesturePoint = gestureRecognizer.location(in: view)

                centerXConstraint.constant += gesturePoint.x - panGestureAnchorPoint.x
                centerYConstraint.constant += gesturePoint.y - panGestureAnchorPoint.y

                self.panGestureAnchorPoint = gesturePoint
            case .cancelled, .ended:
                panGestureAnchorPoint = nil

            case .failed, .possible:
                break
            default:
                break
        }
    }

    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard pinchGestureRecognizer === gestureRecognizer else {
            return
        }

        switch gestureRecognizer.state {
            case .began:
                pinchGestureAnchorScale = gestureRecognizer.scale

            case .changed:
                guard let pinchGestureAnchorScale = pinchGestureAnchorScale else {
                    return
                }

                let gestureScale = gestureRecognizer.scale
                scale += gestureScale - pinchGestureAnchorScale
                self.pinchGestureAnchorScale = gestureScale

            case .cancelled, .ended:
                pinchGestureAnchorScale = nil

            case .failed, .possible:
                break
            default:
                break
        }
    }

    @objc func handleRotationGesture(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard rotationGestureRecognizer === gestureRecognizer else {
            return
        }

        switch gestureRecognizer.state {
            case .began:
                rotationGestureAnchor = gestureRecognizer.rotation
            case .changed:
                guard let rotationGestureAnchor = rotationGestureAnchor else {
                    return
                }

                let gestureRotation = gestureRecognizer.rotation
                rotate += gestureRotation - rotationGestureAnchor
                self.rotationGestureAnchor = gestureRotation

            case .cancelled, .ended:
                rotationGestureAnchor = nil
            case .failed, .possible:
                break
            default:
                break
        }
    }

    @objc func handleSingleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {

        guard singleTapGestureRecognizer === gestureRecognizer else {
            return
        }
        
        blueView.backgroundColor = colorsOfView.randomElement()
    }
    
    @objc func handleResetViewPositionGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        
        scale = 1
        rotate = 0
        centerXConstraint.constant = 0
        centerYConstraint.constant = 0
    }
    
}

extension ViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let simultaneousRecoznizers = [panGestureRecognizer, pinchGestureRecognizer, rotationGestureRecognizer]
        
        return simultaneousRecoznizers.contains(gestureRecognizer) && simultaneousRecoznizers.contains(otherGestureRecognizer)
        
    }
}
