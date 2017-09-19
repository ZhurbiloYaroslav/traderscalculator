//
//  adBannerView.swift
//  TraderCalculator
//
//  Created by Yaroslav Zhurbilo on 19.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import UIKit

class AdBannerView: UIView {
    
    static let adImages = ["Mob_320x50_1.png", "Mob_320x50_2.png"]
    
    static var currentImageIndex = 0
    
    func showAdvertAfterBannerPressed() {
        
        if let url = URL(string: "http://serv.markets.com/promoRedirect?key=ej0xNTM1MzQxNSZsPTE1MzUzNDAyJnA9Mzc1ODU="){
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
        
    }
    
    func configure() {
        
        self.addSubview(adImageView)
        self.addSubview(adButton)
        
        setButtonConstraints()
        setImageConstraints()
        
        setTimer()
        
    }
    
    func setTimer() {
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
    }
    
    func changeImage() {
        
        changeImageIndex()
        adImageView.image = UIImage(named: AdBannerView.adImages[AdBannerView.currentImageIndex])
        
    }
    
    private func changeImageIndex() {
        if AdBannerView.currentImageIndex == (AdBannerView.adImages.count - 1) {
            AdBannerView.currentImageIndex = 0
        } else {
            AdBannerView.currentImageIndex += 1
        }
    }
    
    private let adButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(showAdvertAfterBannerPressed), for: .touchUpInside)
        
        return button
    }()
    
    private let adImageView: UIImageView = {
        print("added new image view")
        print("change image...", AdBannerView.currentImageIndex)
        
        let theImageView = UIImageView()
        theImageView.image = UIImage(named: AdBannerView.adImages[AdBannerView.currentImageIndex])
        theImageView.translatesAutoresizingMaskIntoConstraints = false
        theImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        return theImageView
    }()
    
    private func setButtonConstraints() {
        self.addConstraint(NSLayoutConstraint(item: adButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: adButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: adButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: adButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    private func setImageConstraints() {
        adImageView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        adImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        adImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        adImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    private let adButtonWithImage: UIButton = {
        let image = UIImage(named: AdBannerView.adImages[AdBannerView.currentImageIndex])
        let button = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showAdvertAfterBannerPressed), for: .touchUpInside)
        
        return button
    }()
    
}
