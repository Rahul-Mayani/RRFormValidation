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
        setFormViewModel()
    }
    
    // MARK: - Others -
    fileprivate func setFormViewModel() {
                
        formViewModel.nameSubject <~> nameTextField.rx.text => rxbag // Two-way binding is donated by <~>
        formViewModel.emailSubject <~> mailTextField.rx.text => rxbag // Two-way binding is donated by <~>
        formViewModel.mobileSubject <~> mobNoTextField.rx.text => rxbag // Two-way binding is donated by <~>
        formViewModel.passwordSubject <~> passwordTextField.rx.text => rxbag // Two-way binding is donated by <~>
        formViewModel.submitButtonEnabled ~> submitButton.rx.valid => rxbag // One-way binding is donated by ~>
        submitButton.rx.bind(to: formViewModel.submitAction, input: ()) // action binding
        
        formViewModel.submitAction.executionObservables.switchLatest()
        .subscribe(onNext: { formData in
            print(formData.parameters as Any)
            UIAlertController.showAlert(title: "Form Validator", message: "Success")
        }) => rxbag
        
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
}

