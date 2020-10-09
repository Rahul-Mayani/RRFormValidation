# RRFormValidation

[![iOS](https://img.shields.io/badge/Platform-iOS-orange.svg?style=flat)](https://developer.apple.com/ios/)
[![Swift 5+](https://img.shields.io/badge/Swift-5+-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Validation](https://img.shields.io/badge/Rx-Validation-orange.svg?style=flat)](https://github.com/Rahul-Mayani/RRFormValidation/)
[![Architecture](https://img.shields.io/badge/Architecture%20Pattern-MVVM-green.svg?style=flat)](https://github.com/Rahul-Mayani/RRFormValidation/)


Form validation by RxSwift with MVVM architecture

## Example
![alt text](https://github.com/Rahul-Mayani/RRFormValidation/blob/master/sample.mov)

## Requirements

pod 'RxCocoa'

pod 'RxSwift'

pod 'Action'

pod 'IQKeyboardManagerSwift'

## Installation

#### Manually
1. Download the project.
2. Add necessary files in your project.
3. Congratulations!  

## Usage example
To run the example project, clone the repo, and run pod install from the Example directory first.


```swift

formViewModel.nameSubject <~> nameTextField.rx.text => rxbag // Two-way binding is donated by <~>
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

```

## Contribute 

We would love you for the contribution to **RRFormValidation**, check the ``LICENSE`` file for more info.


## License

RRFormValidation is available under the MIT license. See the LICENSE file for more info.
