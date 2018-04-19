//
//  Extensions.swift
//  MovieViewer
//
//  Created by Kevin Maloles on 4/18/18.
//  Copyright © 2018 Kevin Maloles. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import PKHUD
import Darwin

extension UIImageView {
    func downloadImageFromUrl(_ url: String, defaultImage: UIImage? = nil, callback: (((UIImage?,NSError?,CacheType,URL?))->())? = nil) {
        let url = URL(string: "\(url)")
        self.kf.setImage(with: url, placeholder: defaultImage, completionHandler: callback)
    }
}

extension Double {
    func toHours() -> String {
        let hours = floor(self/60)
        let mins = self.truncatingRemainder(dividingBy: 60)
        return "\(Int(hours))hrs \(Int(mins))mins"
    }
}

extension UIViewController {
    
    func showLoading() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
    }
    
    func hideLoading() {
        PKHUD.sharedHUD.hide()
    }
    
    func getDeviceWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    
}

extension UIView {
    func addBorder(color: UIColor) {
        let color = color.cgColor
        
        self.layer.borderWidth = 1
        
        self.layer.borderColor = color
    }
}


extension UICollectionViewCell {
    class func nib() -> UINib {
        return UINib(nibName: handyClassName(), bundle: Bundle(for: self))
    }
    
    class func reuseIdentifier() -> String {
        return handyClassName()
    }
    
    class func handyClassName() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension Double {
    func toCurrency(maxFractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = floor(self) == self ? maxFractionDigits:2
        formatter.locale = Locale(identifier: "fil_PH")
        let result = formatter.string(from: self as NSNumber)
        return result
    }
}
