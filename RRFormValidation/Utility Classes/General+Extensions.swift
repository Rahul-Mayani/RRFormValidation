//
//  General+Extensions.swift
//  RRFormValidation
//
//  Created by Rahul Mayani on 06/07/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import UIKit

public extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        return self == nil || self!.isEmpty
    }
}

extension Encodable {
    var parameters: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension CGRect {
    
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

extension String{
    
    func isEmpty() -> Bool{
        return self.trim().count == 0
    }

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func isValidName() -> Bool {
        
        if self.trim().count > 0 {
            return true
        }
        return false
        
        
    }
   
    func isValidFullname() -> Bool {
        
        let emailRegEx = "^[A-Za-z]+(?:\\s[A-Za-z]+)"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
        
    }
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "^[+\\w\\.\\-']+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*(\\.[a-zA-Z]{2,})+$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
        
    }
    
    func isValidURL() -> Bool {
        /*guard let urlString = self else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.sharedApplication().canOpenURL(url) {return false}*/
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        // Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-+.,|_~`'\"]).{8,}$")
        return passwordTest.evaluate(with: self)
    }
    
    func isNumeric() -> Bool {
        
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
    
    func isValidMobile() -> Bool {
        
        
        if self.count > 7 && self.count < 15 {
            return true
        }
        return false
        
    }
    
    func isValidZipCode() -> Bool {
        
        if self.count > 2 && self.count < 10 {
            return true
        }
        return false
    }
}

extension UIView {
    
    func setUpRRView() {
        layer.cornerRadius = 5.0
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5.0
        //layer.masksToBounds = true
        
        //clipsToBounds = true
        
        backgroundColor = UIColor.white
    }
    
    func setUpBoxLineRRView() {
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.4
        
        layer.masksToBounds = true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5.0
        
        clipsToBounds = true
        
        backgroundColor = UIColor.white
    }
    
    func setUpSearchBoxLineRRView() {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5.0
        clipsToBounds = true
        backgroundColor = UIColor.white
    }

}

extension UIView {
    
    // MARK: Set & Get Frame
    
    /**
     Get Set x Position
     
     - parameter x: CGFloat
     by DaRk-_-D0G
     */
    var x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    /**
     Get Set y Position
     
     - parameter y: CGFloat
     by DaRk-_-D0G
     */
    var y:CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    /**
     Get Set Height
     
     - parameter height: CGFloat
     by DaRk-_-D0G
     */
    var height:CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    /**
     Get Set Width
     
     - parameter width: CGFloat
     by DaRk-_-D0G
     */
    var width:CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    // MARK: top, right, bottom, left, center x&y and size|origin
    
    public var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    public var right: CGFloat {
        get { return self.frame.origin.x + self.width }
        set { self.frame.origin.x = newValue - self.width }
    }
    public var bottom: CGFloat {
        get { return self.frame.origin.y + self.height }
        set { self.frame.origin.y = newValue - self.height }
    }
    public var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    public var centerX: CGFloat{
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue,y: self.centerY) }
    }
    public var centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.centerX,y: newValue) }
    }
    
    public var origin: CGPoint {
        set { self.frame.origin = newValue }
        get { return self.frame.origin }
    }
    public var size: CGSize {
        set { self.frame.size = newValue }
        get { return self.frame.size }
    }
    
    // MARK: - Others -
    
    public class func fromNib(_ nibNameOrNil:String) ->  UIView {
        return  Bundle.main.loadNibNamed(nibNameOrNil, owner: self, options: nil)!.first as! UIView
    }
    public func makeRound(borderWidth: CGFloat = 1, borderColor: UIColor){
        self.layer.cornerRadius  = self.layer.frame.height / 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func bottomLine(color: UIColor = .white) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(0, height - 1, width, 1)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
    }
    
    // MARK: - IBInspectable -
    @IBInspectable public var viewCornerRadius: CGFloat {
        get { return self.viewCornerRadius }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { return layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    // MARK: - Animation -
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: "transform.rotation")
    }

    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x + 20.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x , y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func blink(_ repeatCount: Float = 3) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.isRemovedOnCompletion = false
        animation.fromValue           = 1
        animation.toValue             = 0
        animation.duration            = 0.7
        animation.autoreverses        = true
        animation.repeatCount         = repeatCount
        animation.beginTime           = CACurrentMediaTime() + 0.5
        self.layer.add(animation, forKey: "opacity")
    }
    
    func setAnimationType(type : String) {
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.duration = 0.4
        transition.subtype = CATransitionSubtype(rawValue: type) //kCATransitionFromTop
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.layer.add(transition, forKey: "SwitchToView1")
    }
}

// MARK: - Animate View
extension UIView {

    // Will take screen shot of whole screen and return image. It's working on main thread and may lag UI.
    func takeScreenShot() -> UIImage {
        UIGraphicsBeginImageContext(bounds.size)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let rec = bounds
        drawHierarchy(in: rec, afterScreenUpdates: true)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

    func inAnimate() {
        self.alpha = 1.0
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.01, 0.6, 1]
        animation.keyTimes = [0, 0.3, 0.5]
        animation.duration = 0.5
        self.layer.add(animation, forKey: "bounce")
    }

    func outAnimation(comp: @escaping ((Bool) -> Void)) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            comp(true)
        })

        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1, 0.6, 0.01]
        animation.keyTimes = [0, 0.3, 0.5]
        animation.duration = 0.2
        self.layer.add(animation, forKey: "bounce")
        CATransaction.commit()
    }
    
    func blinkAnimation(_ repeatCount: Float = 1000000000) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.isRemovedOnCompletion = false
        animation.fromValue           = 1
        animation.toValue             = 0
        animation.duration            = 0.7
        animation.autoreverses        = true
        animation.repeatCount         = repeatCount
        animation.beginTime           = CACurrentMediaTime() + 0.5
        self.layer.add(animation, forKey: "opacity")
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
