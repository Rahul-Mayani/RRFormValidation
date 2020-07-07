//
//  RRFormTextField.swift
//  RRFormValidation
//
//  Created by Rahul Mayani on 06/07/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RRTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        setupAppTextField()
        
        if !isEnabled {
            backgroundColor = UIColor.darkGray
        }
    }
}

class RRSearchTextField: SearchTextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        clearsOnBeginEditing = true
        clearButtonMode = .whileEditing
        
        setupSearchAppTextField()
                
        theme.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        theme.fontColor = UIColor.black
        theme.bgColor = UIColor.white
        theme.borderColor = UIColor.blue.withAlphaComponent(0.2)
        theme.separatorColor = UIColor.darkGray
        theme.cellHeight = 40
        //maxResultsListHeight = 200
        theme.placeholderColor = UIColor.lightGray
        
        highlightAttributes = [.foregroundColor: UIColor.blue]
    }
}

class RRPhoneNumberTextField: PhoneNumberTextField  {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func setupUI() {
        setupAppTextField()
        withPrefix = true
        withFlag = true
        withExamplePlaceholder = true
        withDefaultPickerUI = true
    }
    
    func rxMobNoOptionalValidator() -> Observable<Bool> {
        return self.rx.text.map({ [weak self] (text) -> Bool in
            guard let self = self else {return false}
            return (self.text?.count ?? 0) > 0 ? self.isValidNumber : true
        }).share(replay: 1, scope: .forever).asObservable()
    }
    
    func rxMobNoValidator() -> Observable<Bool> {
        return self.rx.text.map({ [weak self] (text) -> Bool in
            guard let self = self else {return false}
            return self.isValidNumber
        }).share(replay: 1, scope: .forever).asObservable()
    }

}

extension RRPhoneNumberTextField {
    
    static func getMobileNumberFormatedText(_ mobNo: String) -> String {
        let phoneNumberField = RRPhoneNumberTextField(frame: CGRect.zero)
        phoneNumberField.text = mobNo
        do {
            let phoneNumber = try phoneNumberField.phoneNumberKit.parse(phoneNumberField.text!)
            return phoneNumberField.phoneNumberKit.format(phoneNumber, toType: .international, withPrefix: true)
        }
        catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    func getNumber() -> String {
        return nationalNumber
    }
    
    func getNumberCode() -> String {
        return partialFormatter.prefixBeforeNationalNumber.trim()
    }
}
 
class RRFormTextField: FormTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        for subview in subviews {
            if let label = subview as? UILabel {
                label.minimumScaleFactor = 0.3
                label.adjustsFontSizeToFitWidth = true
            }
        }
    }
    
    func setup() {
        inputType = .integer
        DispatchQueue.main.async {
            self.setupAppTextField()
        }
    }
    
    func rxCardValidator() -> Observable<Bool> {
        return self.rx.text.map({ [weak self] (text) -> Bool in
            guard let self = self else {return false}
            return self.validate()
        }).share(replay: 1, scope: .forever).asObservable()
    }
}

struct RRFormTextFieldStyle {
    static func apply() {
        
        let enabledBackgroundColor = UIColor.white
        let enabledBorderColor = UIColor.darkGray
        let enabledTextColor = UIColor.black
        
        let activeBorderColor = UIColor.darkGray
        
        let disabledBackgroundColor = enabledBackgroundColor
        let disabledBorderColor = enabledBorderColor
        let disabledTextColor = UIColor.red

        FormTextField.appearance().clearButtonColor = UIColor.clear

        FormTextField.appearance().enabledBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().enabledBorderColor = enabledBorderColor
        FormTextField.appearance().enabledTextColor = enabledTextColor

        FormTextField.appearance().validBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().validBorderColor = enabledBorderColor
        FormTextField.appearance().validTextColor = enabledTextColor

        FormTextField.appearance().activeBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().activeBorderColor = activeBorderColor
        FormTextField.appearance().activeTextColor = enabledTextColor

        FormTextField.appearance().inactiveBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().inactiveBorderColor = enabledBorderColor
        FormTextField.appearance().inactiveTextColor = enabledTextColor

        FormTextField.appearance().disabledBackgroundColor = disabledBackgroundColor
        FormTextField.appearance().disabledBorderColor = disabledBorderColor
        FormTextField.appearance().disabledTextColor = disabledTextColor

        FormTextField.appearance().invalidBackgroundColor = disabledBackgroundColor
        FormTextField.appearance().invalidBorderColor = disabledBorderColor
        FormTextField.appearance().invalidTextColor = disabledTextColor
    }
}
