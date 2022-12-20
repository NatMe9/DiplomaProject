//
//  ZeroView.swift
//  tms-25-zeroview-xib
//
//  Created by Artur Igberdin on 18.11.2022.
//

import UIKit
import Lottie

class ZeroView: UIView {

    var animationView: LottieAnimationView!

    init(jsonName: String) {
        super.init(frame: .zero)

        self.backgroundColor = .white

        setupAnimation(jsonName)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fatalError("init(coder:) has not been implemented")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
       // fatalError("init(coder:) has not been implemented")
       
    }

    func setupAnimation(_ jsonName: String) {
       //Create animation
       // let jsonName = "car-loader"
        let animation = LottieAnimation.named(jsonName)

        // Load animation to AnimationView
        animationView = LottieAnimationView(animation: animation)
        //animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        self.addSubview(animationView)

        animationView.pinEdgesToSuperView()

        animationView.play()

        animationView.loopMode = .loop
        
    }

    func startAnimation() {
        // Play the animation
        animationView.play()
    }

    func stopAnimation() {
        animationView.stop()
    }
}
