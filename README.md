# RRFormValidation
Form validation by RxSwift with MVVM architecture

## Requirements

pod 'RxCocoa'

pod 'RxSwift'

pod 'IQKeyboardManagerSwift'

## Installation

#### Manually
1. Download the project.
2. Add necessary files in your project.
3. Congratulations!  

## Usage example
To run the example project, clone the repo, and run pod install from the Example directory first.


```swift

nameTextField.rx.text.asObservable()
.ignoreNil()
.subscribe(formViewModel.nameSubject)
.disposed(by: rxbag)

submitButton.rx.tap.asObservable()
.debounce(.milliseconds(1), scheduler: RXScheduler.main)
.subscribe(formViewModel.submitDidTapSubject)
.disposed(by: rxbag)

formViewModel.formResultSubject
.filter({ (formData) -> Bool in
    return !formData.email.isEmpty
})
.subscribe(onNext: { formData in
    self.submitButton?.stopAnimation()
    print(formData.parameters as Any)
    UIAlertController.showAlert(title: "Form Validator", message: "Success")
}).disposed(by: rxbag)

formViewModel.formLoadingSubject
.subscribe(onNext: { [weak self] (isLoading) in
    guard let self = self else {return}
    self.view.endEditing(true)
    if isLoading {
        self.submitButton?.startAnimation()
    }
}).disposed(by: rxbag)

```

## Contribute 

We would love you for the contribution to **RRFormValidation**, check the ``LICENSE`` file for more info.


## License

RRFormValidation is available under the MIT license. See the LICENSE file for more info.
