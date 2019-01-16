//  AnimationViewController.swift
//  FlickrViewTakeHomeProject
//  Created by George Garcia on 1/14/19.
//  Copyright © 2019 George Garcia. All rights reserved.

//  Description: This ViewController has the animation configuration. Where we use the Lottie Framework to play the animation
//  Pretty much the mimicking the LaunchScreen

import UIKit
import Lottie

class AnimationViewController: UIViewController {
    
    var window: UIWindow?
    
    @IBOutlet weak var flickrAnimationView: LOTAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        
        Timer.scheduledTimer(timeInterval: 4.5, target: self, selector: #selector(self.splashTimeOut(sender:)), userInfo: nil, repeats: false)
        
    }
    
    func startAnimation() {
        flickrAnimationView.setAnimation(named: "flickrviewer_animation")
        flickrAnimationView.play()
    }
    
    @objc func splashTimeOut(sender: Timer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "initialVC")
        
        AppDelegate.sharedInstance().window?.rootViewController = initialViewController
        
    }
}
