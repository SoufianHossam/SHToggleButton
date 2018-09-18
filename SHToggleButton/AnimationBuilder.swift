//
//  AnimationBuilder.swift
//  SHToggleButton
//
//  Created by Soufian Hossam on 9/17/18.
//  Copyright © 2018 Soufian Hossam. All rights reserved.
//

import UIKit

class AnimationBuilder {
    private var view: UIView
    
    private var translationX: CGFloat = 0
    private var translationY: CGFloat = 0
    
    private var angle: CGFloat = 0
    
    private var scaleX: CGFloat = 1
    private var scaleY: CGFloat = 1
    
    private var duration: TimeInterval = 0
    private var damping: CGFloat = 1
    private var delay: TimeInterval = 0
    private var velocity: CGFloat = 0
    
    private var alphaStart: CGFloat = 1
    private var alphaEnd: CGFloat = 1
    
    private var options: UIViewAnimationOptions = []
    
    private var transformation: CGAffineTransform {
        return CGAffineTransform.identity.translatedBy(x: translationX, y: translationY)
            .rotated(by: angle)
            .scaledBy(x: scaleX, y: scaleY)
    }
    
    enum BuildType {
        case permanent
        case transitional
    }
    
    // MARK: - Init
    init(for view: UIView) {
        self.view = view
    }
    
    func translateX(_ x: CGFloat) -> AnimationBuilder {
        translationX = x
        return self
    }
    
    func translateY(_ y: CGFloat) -> AnimationBuilder {
        translationY = y
        return self
    }
    
    func scaleX(_ x: CGFloat) -> AnimationBuilder {
        scaleX = x
        return self
    }
    
    func scaleY(_ y: CGFloat) -> AnimationBuilder {
        scaleY = y
        return self
    }
    
    func rotate(_ degree: Double) -> AnimationBuilder {
        let radian = CGFloat(degree * Double.pi / 180)
        self.angle = radian
        return self
    }
    
    // MARK: - Animation Configuration
    func duration(_ duration: TimeInterval) -> AnimationBuilder {
        self.duration = duration
        return self
    }
    
    func delay(_ delay: TimeInterval) -> AnimationBuilder {
        self.delay = delay
        return self
    }
    
    func damping(_ damping: CGFloat) -> AnimationBuilder {
        self.damping = damping
        return self
    }
    
    func initialVeclocity(_ velocity: CGFloat) -> AnimationBuilder {
        self.velocity = velocity
        return self
    }
    
    func alpha(_ alphaStart: CGFloat, _ alphaEnd: CGFloat) -> AnimationBuilder {
        self.alphaStart = alphaStart
        self.alphaEnd = alphaEnd
        return self
    }
    
    func options(_ options: UIViewAnimationOptions) -> AnimationBuilder {
        self.options = options
        return self
    }
    
    // MARK: - Functions
    typealias VoidBlock = () -> Void
    
    private func permanentAnimation(completeBlock: VoidBlock? = nil) {
        view.alpha = alphaStart
        
        animationBlock(completeBlock: completeBlock) {
            self.view.alpha = self.alphaEnd
            self.view.transform = self.transformation
        }
    }
    
    private func transitionalAnimation(completeBlock: VoidBlock? = nil) {
        view.transform = transformation
        view.alpha = alphaStart
        
        animationBlock(completeBlock: completeBlock) {
            self.view.alpha = self.alphaEnd
            self.view.transform = .identity
        }
    }
    
    private func animationBlock(completeBlock: VoidBlock? = nil, completion: @escaping VoidBlock) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.duration, delay: self.delay, usingSpringWithDamping: self.damping,
                           initialSpringVelocity: self.velocity, options: self.options, animations: {
                            completion()
            },completion:{ success in
                completeBlock?()
            })
        }
    }
    
    func execute(type: BuildType, completion: VoidBlock? = nil) {
        switch type {
        case .permanent:
            permanentAnimation(completeBlock: completion)
            
        case .transitional:
            transitionalAnimation(completeBlock: completion)
        }
    }
}

