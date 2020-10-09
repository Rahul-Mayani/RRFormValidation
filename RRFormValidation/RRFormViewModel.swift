//
//  RRFormViewModel.swift
//  RRFormValidation
//
//  Created by Rahul Mayani on 06/07/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class RRFormViewModel {
    
    let nameSubject = BehaviorRelay<String?>(value: nil)
    let emailSubject = BehaviorRelay<String?>(value: nil)
    let mobileSubject = BehaviorRelay<String?>(value: nil)
    let passwordSubject = BehaviorRelay<String?>(value: nil)
    let submitButtonEnabled = BehaviorRelay(value: false)
    
    let formLoadingSubject: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    
    private let mobileTextField = RRPhoneNumberTextField.init(frame: CGRect(0, 0, 0, 0))
    
    private let disposeBag = DisposeBag()
    
    lazy var submitAction: Action<Void, RRFormModel> = {
        return Action(enabledIf: self.submitButtonEnabled.asObservable()) {
            self.formLoadingSubject.accept(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.formLoadingSubject.accept(false)
            }
            return self.getFormData()
        }
    }()
    
    private func getFormData() -> Observable<RRFormModel> {
        let name = self.nameSubject.value ?? ""
        let email = self.emailSubject.value ?? ""
        let mobile = self.mobileSubject.value ?? ""
        let pass = self.passwordSubject.value ?? ""
        self.mobileTextField.text = mobile
        let fromData = RRFormModel.init(name: name, email: email, mobile: !(self.mobileTextField.text?.isEmpty ?? false) ? self.mobileTextField.getNumber() : "", password: pass, countryCode: self.mobileTextField.getNumberCode())
        return .just(fromData)
    }
    
    init() {
        
        Observable.combineLatest(nameSubject, emailSubject, mobileSubject, passwordSubject) { [weak self] (name, email, mobile, password) -> Bool in
            self?.mobileTextField.text = mobile
            return (!password.isNilOrEmpty ? password!.isValidPassword() : false) &&
                    !name.isNilOrEmpty &&
                    (!email.isNilOrEmpty ? email!.isValidEmail() : false) &&
                    (!mobile.isNilOrEmpty ? (self?.mobileTextField.isValidNumber ?? false) : true)
        } ~> submitButtonEnabled => disposeBag // One-way binding is donated by ~>
    }
}
