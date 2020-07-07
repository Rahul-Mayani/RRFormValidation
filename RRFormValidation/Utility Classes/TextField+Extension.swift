//
//  TextField+Extension.swift
//  RRFormValidation
//
//  Created by Rahul Mayani on 06/07/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension UITextField{

   @discardableResult
   public func appLeftView(image: UIImage?, width: CGFloat = 0) -> UIButton {
       
       let widthNew = (width == 0) ? self.frame.size.height : width
       let btn = UIButton.init(type: .custom)
       btn.setImage(image, for: .normal)
       btn.isUserInteractionEnabled = false
       btn.frame = CGRect.init(x: 0, y: 0, width: widthNew, height:  self.frame.size.height)
       let view = UIView.init(frame: CGRect.init(x: (self.frame.size.width - self.frame.size.height), y: 0, width: widthNew, height:  self.frame.size.height))
       view.addSubview(btn)
       view.backgroundColor = UIColor.clear
       self.leftView = view
       self.leftViewMode = .always
       return btn
   }
    
   @discardableResult
   public func rightView(image: UIImage?, width: CGFloat = 0) -> UIButton {
        
        let widthNew = (width == 0) ? self.frame.size.height : width
        let btn = UIButton.init(type: .custom)
        btn.setImage(image, for: .normal)
        btn.isUserInteractionEnabled = false
        btn.frame = CGRect.init(x:  0, y: 10, width:widthNew - 10, height:  self.frame.size.height - 20)
        let view = UIView.init(frame: CGRect.init(x: (self.frame.size.width - self.frame.size.height), y: 0, width: widthNew, height:  self.frame.size.height))
        view.addSubview(btn)
        view.backgroundColor = UIColor.clear
        self.rightView = view
        self.rightViewMode = .always
        return btn
        
    }
    
    @discardableResult
    public func rightViewInfo( width: CGFloat = 0) -> UIButton {
        
        let widthNew = (width == 0) ? self.frame.size.height : width
        let btn = UIButton.init(type: .detailDisclosure)
        btn.frame = CGRect.init(x:0, y: 0, width:widthNew, height:  self.frame.size.height)
        self.rightView = btn
        self.rightViewMode = .always
        return btn
        
    }
    
    public func removeRightView(){
        self.rightView = nil
        self.rightViewMode = .always
        
    }
    
    func leftpedding(){
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(nil, for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width:10, height:  self.frame.size.height)
        self.leftView = btn
        self.leftViewMode = .always
    }

    func leftViewPedding(){
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width:10, height:  self.frame.size.height))
        view.backgroundColor = UIColor.clear
        self.leftView = view
        self.leftViewMode = .always
    }
    
    func rightViewPedding(){
        
        let view = UIView.init(frame: CGRect.init(x: (self.frame.size.width - 10), y: 0, width:10, height:  self.frame.size.height))
        view.backgroundColor = UIColor.clear
        self.rightView = view
        self.rightViewMode = .always
    }
    
    func rxEmptyValidator() -> Observable<Bool> {
        return self.rx.text.orEmpty.map({$0.count > 0}).share(replay: 1, scope: .forever).asObservable()
    }
    
    func rxPasswordEmptyValidator() -> Observable<Bool> {
        return self.rx.text.orEmpty.map({ $0.isValidPassword() }).share(replay: 1, scope: .forever).asObservable()
    }
    
    func rxMailEmptyValidator() -> Observable<Bool> {
        return self.rx.text.orEmpty.map({ $0.isValidEmail() }).share(replay: 1, scope: .forever).asObservable()
    }
    
    func rxMailOptionalValidator() -> Observable<Bool> {
        return self.rx.text.map({ [weak self] (text) -> Bool in
            guard let self = self else {return false}
            return (self.text?.count ?? 0) > 0 ? self.text!.isValidEmail() : true
        }).share(replay: 1, scope: .forever).asObservable()
    }
    
    func rxZipCodeValidator() -> Observable<Bool> {
        return self.rx.text.orEmpty.map({ $0.isValidZipCode() }).share(replay: 1, scope: .forever).asObservable()
    }
    
    func rxZipCodeOptionalValidator() -> Observable<Bool> {
        return self.rx.text.map({ [weak self] (text) -> Bool in
            guard let self = self else {return false}
            return (self.text?.count ?? 0) > 0 ? self.text!.isValidZipCode() : true
        }).share(replay: 1, scope: .forever).asObservable()
    }
    
    func rxMobileNoOrMailValidator() -> Observable<Bool> {
        return self.rx.text.orEmpty.map({
            $0.isNumeric() && $0.isValidMobile() || !$0.isNumeric() && $0.isValidEmail()
        }).share(replay: 1, scope: .forever)
    }
    
    func rxEmailValidator() -> Observable<Bool> {
        return self.rx.text.orEmpty.map({
            !$0.isNumeric() && $0.isValidEmail()
        }).share(replay: 1, scope: .forever)
    }

    func setupAppTextField() {
        borderStyle = .none
        leftViewPedding()
        textColor = UIColor.black
        font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setUpBoxLineRRView()
    }
    
    func setupSearchAppTextField() {
        borderStyle = .none
        leftViewPedding()
        textColor = UIColor.black
        font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setUpSearchBoxLineRRView()
    }

}
