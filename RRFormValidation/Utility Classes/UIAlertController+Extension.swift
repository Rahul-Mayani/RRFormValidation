//
//  UIAlertController+Extension.swift
//  RRFormValidation
//
//  Created by Rahul Mayani on 06/07/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController{
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.tintColor = UIColor.blue
    }
    
    class private func getAlertController(title : String, message : String?) -> UIAlertController {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black]
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.black]

        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont as [NSAttributedString.Key : Any])
        let messageAttrString = NSMutableAttributedString(string: message ?? "", attributes: messageFont as [NSAttributedString.Key : Any])

        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        return alertController
    }
    
    class func showAlert(title : String?, message : String?, handler: ((UIAlertController) -> Void)? = nil){
        let alertController = getAlertController(title: title ?? "", message: message)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            handler?(alertController)
        }))
        //appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    class func showConfirmationAlert(title : String?, message : String?, handler: ((UIAlertController) -> Void)? = nil) {
        let alertController = getAlertController(title: title ?? "", message: message)
        alertController.addAction(UIAlertAction.init(title: "Continue", style: .default, handler: { (action) in
            handler?(alertController)
        }))
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    class func showQuestionConfirmationAlert(title : String?, message : String?, handler: ((UIAlertController) -> Void)? = nil) {
        let alertController = getAlertController(title: title ?? "", message: message)
        alertController.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: { (UIAlertAction) in
            handler?(alertController)
        }))
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    class func showConfAlert(title : String?, message : String?, handler: ((String) -> Void)? = nil) {
        let alertController = getAlertController(title: title ?? "", message: message)
        alertController.addAction(UIAlertAction.init(title: "Continue", style: .default, handler: { (action) in
            handler?("Continue")
        }))
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
            handler?("Cancel")
        }))
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}
