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

class RRFormViewModel {

    let nameSubject = PublishSubject<String>()
    let emailSubject = PublishSubject<String>()
    let mobileSubject = PublishSubject<String>()
    let passwordSubject = PublishSubject<String>()
    let submitDidTapSubject = PublishSubject<Void>()
        
    let formLoadingSubject: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let formResultSubject: BehaviorRelay<RRFormModel> = BehaviorRelay.init(value: RRFormModel())
    
    private let mobileTextField = RRPhoneNumberTextField.init(frame: CGRect(0, 0, 0, 0))
    
    private let disposeBag = DisposeBag()
    
    private var getFormDataObservable: Observable<RRFormModel> {
        return Observable.combineLatest(nameSubject.asObservable(), emailSubject.asObservable(), mobileSubject.asObservable(), passwordSubject.asObservable()) { (name, email, mobile, password) in
            self.mobileTextField.text = mobile
            return RRFormModel.init(name: name, email: email, mobile: !(self.mobileTextField.text?.isEmpty ?? false) ? self.mobileTextField.getNumber() : "", password: password, countryCode: self.mobileTextField.getNumberCode())
        }
    }
    
    init() {
        
        submitDidTapSubject
            .withLatestFrom(self.getFormDataObservable)
            /*.flatMapLatest { fromData in
                // Get response from API calls
                return apiCall.validate(with: fromData)
            }*/
            .subscribe(onNext: { [weak self] (fromData) in
                self?.formLoadingSubject.accept(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
                    self?.formLoadingSubject.accept(false)
                    self?.formResultSubject.accept(fromData)
                }
            }, onError: { [weak self] (error) in
                print(error)
                self?.formLoadingSubject.accept(false)
            }, onCompleted: { [weak self] in
                self?.formLoadingSubject.accept(false)
            }).disposed(by: disposeBag)
    }
}
