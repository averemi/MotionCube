//
//  ViewController.swift
//  Day06
//
//  Created by Anastasiia VEREMIICHYK on 09.04.2019.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    var dynamicBehaviour = UIDynamicItemBehavior(items: [])
    var gravityBehaviour = UIGravityBehavior(items: [])
    var collisionBehaviour = UICollisionBehavior(items: [])
    var dynamicAnimator: UIDynamicAnimator!
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBehaviour()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            let queue = OperationQueue.main
            motionManager.startAccelerometerUpdates(to: queue, withHandler: accelerometerHandler)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if motionManager.isAccelerometerAvailable {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    func addBehaviour() {
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        dynamicAnimator.addBehavior(gravityBehaviour)
        
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehaviour)
        
        dynamicBehaviour.elasticity = 1
        dynamicAnimator.addBehavior(dynamicBehaviour)
    }
    
    func updateState(_ shape: Shape) {
        gravityBehaviour.removeItem(shape)
        collisionBehaviour.removeItem(shape)
        dynamicBehaviour.removeItem(shape)
        dynamicAnimator.updateItem(usingCurrentState: shape)
        collisionBehaviour.addItem(shape)
        dynamicBehaviour.addItem(shape)
    }
    
    func accelerometerHandler(data: CMAccelerometerData?, error: Error?) {
        guard let data = data else { return }
        
        let x = CGFloat(data.acceleration.x)
        let y = CGFloat(data.acceleration.y)
        let vector = CGVector(dx: x, dy: y)
        gravityBehaviour.gravityDirection = vector
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        let shape = Shape(location: sender.location(in: view))

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(gesture:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationGesture(gesture:)))

        view.addSubview(shape)
        gravityBehaviour.addItem(shape)
        collisionBehaviour.addItem(shape)
        dynamicBehaviour.addItem(shape)
        shape.addGestureRecognizer(panGesture)
        shape.addGestureRecognizer(pinchGesture)
        shape.addGestureRecognizer(rotationGesture)
    }

    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        guard let shape = gesture.view as? Shape else { return }

        switch gesture.state {
        case .began:
            gravityBehaviour.removeItem(shape)
        case .changed:
            shape.center = gesture.location(in: view)
            dynamicAnimator.updateItem(usingCurrentState: shape)
        case .ended:
            gravityBehaviour.addItem(shape)
        default:
            print("No changes")
        }
    }
    
    @objc func pinchGesture(gesture: UIPinchGestureRecognizer) {
        guard let shape = gesture.view as? Shape else { return }

        switch gesture.state {
        case .began:
            updateState(shape)
        case .changed:
            print("pinch")
            var newSize = gesture.scale * shape.layer.bounds.size.height
            
            if newSize <= 2 {
                newSize = 2
            }
            if newSize <= UIScreen.main.bounds.width && newSize <= UIScreen.main.bounds.height {
                shape.layer.bounds.size.height = newSize
                shape.layer.bounds.size.width = newSize
                if !shape.isSquare {
                    shape.layer.cornerRadius = newSize / 2
                }
                updateState(shape)
            }
        case .ended:
            gravityBehaviour.addItem(shape)
        default:
            print("No changes")
        }
    }
    
    @objc func rotationGesture(gesture: UIRotationGestureRecognizer) {
        guard let shape = gesture.view as? Shape else { return }
        
        switch gesture.state {
        case .began:
            updateState(shape)
        case .changed:
            shape.transform = CGAffineTransform(rotationAngle: gesture.rotation)
            print("rotate")
            updateState(shape)
        case .ended:
            gravityBehaviour.addItem(shape)
        default:
            print("No changes")
        }
    }
}

