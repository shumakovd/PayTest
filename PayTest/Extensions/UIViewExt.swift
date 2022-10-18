//
//  UIViewExt.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit
import Lottie
import Foundation

// MARK: - IBInspectable -

extension UIView {
    @IBInspectable var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
        
    @IBInspectable var borderWidthView: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
        
    @IBInspectable var borderColorView: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIView {
    
    // MARK: - Animation
    
    static var lottie_gradient_loader = LottieAnimation.named("gradient-stroke-loader")
    
    func startAnimation() {
        let backgroundView = UIView()
        backgroundView.tag = 1010
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let animationView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        let animation = LottieAnimationView(animation: UIView.lottie_gradient_loader)
        
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        animation.play()
        animation.frame = animationView.bounds
        
        animationView.addSubview(animation)
        animationView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        //
        backgroundView.insertSubview(blurEffectView, at: 0)
        backgroundView.insertSubview(animationView, at: 1)
        //
        self.addSubview(backgroundView)
    }
    
    func stopAnimation() {
        if let view = self.viewWithTag(1010) {
            view.removeFromSuperview()
        }
    }        
    
    func bounce(){
        
        UIView.animate(withDuration: 0.1,
        animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
}
