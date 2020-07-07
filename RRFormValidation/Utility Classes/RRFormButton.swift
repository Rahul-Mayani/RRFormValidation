//
//  RRFormButton.swift
//  RRFormValidation
//
//  Created by Rahul Mayani on 06/07/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import UIKit

enum TransitionDuration: Double {
    case shake = 0.0
    case expand = 0.2
}

class RRFormButton: TransitionButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        
        spinnerColor = UIColor.white
        cornerRadius = 5.0//height / 2
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        setTitleColor(UIColor.white, for: .normal)
        setTitle(titleLabel?.text, for: .normal)
        setTitle(titleLabel?.text, for: .disabled)
        setTitleColor(UIColor.white, for: .disabled)
        backgroundColor = UIColor.blue
        layer.masksToBounds = true
    }
    
}

extension RRFormButton {
    
    open func showSuccess(_ style: StopAnimationStyle = .normal, completion:(()->Void)? = nil) {
        stopAnimation(animationStyle: style, revertAfterDelay: TransitionDuration.expand.rawValue, completion: completion)
    }
    
    open func showErrorAlert(_ message: String = "") {
        if !message.isEmpty {
            UIAlertController.showAlert(title: nil, message: message)
        }
        stopAnimation(animationStyle: .shake, revertAfterDelay: TransitionDuration.shake.rawValue, completion: nil)
    }
}
