//
//  RRFormViewController.swift
//  RRFormValidation
//
//  Created by Rahul Mayani on 06/07/20.
//  Copyright © 2020 RR. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class RRFormViewController: UIViewController {

    // MARK: - IBOutlet -
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var mailTextField : UITextField!
    @IBOutlet weak var mobNoTextField : RRPhoneNumberTextField!
    @IBOutlet weak var passwordTextField : UITextField!
    
    @IBOutlet weak var submitButton: RRFormButton!
    
    // MARK: - Variable -
    let rxbag = DisposeBag()
    
    private let formViewModel = RRFormViewModel()
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //validator()
        setFormViewModel()
        //setupAllButton()
    }
    /*
    // MARK: - Others -
    fileprivate func validator() {
        
        Observable.combineLatest(nameTextField.rxEmptyValidator(), mailTextField.rxMailEmptyValidator(), mobNoTextField.rxMobNoOptionalValidator(), passwordTextField.rxPasswordEmptyValidator()) { (name, mail, mobile, password) in
            return password && name && mail && mobile
        }.bind(to: submitButton.rx.valid).disposed(by: rxbag)
        /*
        Observable.combineLatest([nameTextField.rxEmptyValidator(), mailTextField.rxMailEmptyValidator(), mobNoTextField.rxMobNoOptionalValidator(), passwordTextField.rxEmptyValidator()]) { (validator) in
            return validator[0] && validator[1] && validator[2] && validator[3]
        }.bind(to: submitButton.rx.valid).disposed(by: rxbag)
        */
    }
    */
    fileprivate func setFormViewModel() {
                
        formViewModel.nameSubject <~> nameTextField.rx.text => rxbag // Two-way binding is donated by <~>
        formViewModel.emailSubject <~> mailTextField.rx.text => rxbag // Two-way binding is donated by <~>
        formViewModel.mobileSubject <~> mobNoTextField.rx.text => rxbag // Two-way binding is donated by <~>
        formViewModel.passwordSubject <~> passwordTextField.rx.text => rxbag // Two-way binding is donated by <~>
        formViewModel.submitButtonEnabled ~> submitButton.rx.valid => rxbag // One-way binding is donated by ~>
        submitButton.rx.bind(to: formViewModel.submitAction, input: ()) // action binding
        
        /*nameTextField.rx.text.asObservable()
            .ignoreNil()
            .subscribe(formViewModel.nameSubject)
            .disposed(by: rxbag)
        
        mailTextField.rx.text.asObservable()
            .ignoreNil()
            .subscribe(formViewModel.emailSubject)
            .disposed(by: rxbag)
        
        mobNoTextField.rx.text.asObservable()
            .ignoreNil()
            .subscribe(formViewModel.mobileSubject)
            .disposed(by: rxbag)
        
        passwordTextField.rx.text.asObservable()
            .ignoreNil()
            .subscribe(formViewModel.passwordSubject)
            .disposed(by: rxbag)
        
        submitButton.rx.tap.asObservable()
            .debounce(.milliseconds(1), scheduler: RXScheduler.main)
            .subscribe(formViewModel.submitDidTapSubject)
            .disposed(by: rxbag)
        */
        
        formViewModel.submitAction.executionObservables.switchLatest()
        .subscribe(onNext: { formData in
            print(formData.parameters as Any)
            UIAlertController.showAlert(title: "Form Validator", message: "Success")
        }) => rxbag
        /*
        formViewModel.formResultSubject
            .filter({ (formData) -> Bool in
                return !formData.email.isEmpty
            })
            .subscribe(onNext: { formData in
                self.submitButton?.stopAnimation()
                print(formData.parameters as Any)
                UIAlertController.showAlert(title: "Form Validator", message: "Success")
            }) => rxbag
        */
        
        formViewModel.formLoadingSubject.skip(1)
        .subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else {return}
            self.view.endEditing(true)
            if isLoading {
                self.submitButton?.startAnimation()
            } else {
                self.submitButton?.stopAnimation()
            }
        }) => rxbag
    }
    /*
    // MARK: - Buttons Action -
    fileprivate func setupAllButton() {
        submitButton.rx.tap.bind{ [weak self] _ in
            guard let self = self else {return}
            self.view.endEditing(true)
            let formParam = RRFormModel.init(name: self.nameTextField.text!, email: self.mailTextField.text!, mobile: !(self.mobNoTextField.text?.isEmpty ?? false) ? self.mobNoTextField.getNumber() : "", password: self.passwordTextField.text!, countryCode: self.mobNoTextField.getNumberCode())
            self.submitButton?.startAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                self.submitButton?.showSuccess(completion: {
                    print(formParam.parameters as Any)
                })
            }
        }.disposed(by: rxbag)
    }*/
}

