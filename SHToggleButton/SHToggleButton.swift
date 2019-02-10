//
//  SHToggleButton.swift
//  SHToggleButton
//
//  Created by Soufian Hossam on 9/18/18.
//  Copyright © 2018 Soufian Hossam. All rights reserved.
//

import UIKit

@IBDesignable
class SHToggleButton: UIButton {
    // MARK: - Variables
    private var fallingImage: UIImage?
    
    // MARK: - IBInspectable
    @IBInspectable var defaultImage: UIImage? {
        didSet {
            setImage(defaultImage, for: .normal)
        }
    }
    
    @IBInspectable var selectedImage: UIImage? {
        didSet {
            setImage(selectedImage, for: .selected)
        }
    }
    
    @IBInspectable var imageToAnimate: UIImage? {
        didSet {
            fallingImage = imageToAnimate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isSelected = false
        addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    @objc private func tap() {
        isSelected = !isSelected
        
        if isSelected {
            bounceAnimation()
            fallingAnimation()
        }
    }
    
    private func bounceAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0, animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            
            }, completion: { _ in
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                })
            })
        }
    }
    
    private func fallingAnimation() {
        let x = frame.width / 2
        let y = frame.height / 2
        
        for _ in 0...3 {
            let duration = 0.5 + drand48() * 0.5
            
            let imageView = UIImageView(image: fallingImage)
            imageView.frame = CGRect(x: x, y: y, width: frame.width * 0.7, height: frame.height * 0.7)
            
            addSubview(imageView)
            
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.path = createFallingPath(center: CGPoint(x: x, y: y))
            animation.duration = duration
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.isRemovedOnCompletion = false
            animation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]
            
            imageView.layer.add(animation, forKey: nil)
            
            UIView.animate(withDuration: duration, animations: {
                imageView.alpha = 0
            }, completion: { success in
                imageView.removeFromSuperview()
            })
        }
    }
    
    private func createFallingPath(center: CGPoint) -> CGPath {
        let lowerValue = -50
        let upperValue = 50
        let random = Double(Int(arc4random_uniform(UInt32(upperValue - lowerValue + 1))) + lowerValue)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: center.x, y: center.y))
        
        let y = center.y + 200
        let endPoint = CGPoint(x: center.x + CGFloat(random), y: y)
        
        let cp1 = CGPoint(x: Double(center.x) + random, y: Double(center.y) - 80)
        let cp2 = CGPoint(x: Double(center.x) + random, y: Double(center.y) - 80)
        
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        path.stroke()
        path.lineWidth = 3
        
        return path.cgPath
    }
}
