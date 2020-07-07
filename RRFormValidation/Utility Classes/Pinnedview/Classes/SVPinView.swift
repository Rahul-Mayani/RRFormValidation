

import UIKit

@objc
public enum SVPinViewStyle : Int {
    case none = 0
    case underline
    case box
}

@objc
public class SVPinView: UIView {
    
    @IBOutlet fileprivate var collectionView : UICollectionView!
    /*
    fileprivate var flowLayout: UICollectionViewFlowLayout {
        return self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
    }
    */
    public var pinLength:Int = 6
    public var secureCharacter:String = "\u{25CF}"
    public var cellLeftRightSpace: CGFloat = 60
    private var cellSize: CGFloat = 0
    public var interSpace:CGFloat = 5{
        didSet{
            let totalWidth = UIScreen.main.bounds.size.width - (cellLeftRightSpace + CGFloat((pinLength - 1) * Int(interSpace)))
            //let utilizeSpace: CGFloat = CGFloat(40 * pinLength)
            //let remainingSpace = totalWidth - utilizeSpace
            //interSpace = remainingSpace / 5
            cellSize = totalWidth / CGFloat(pinLength)
            if collectionView != nil {
                collectionView.reloadData()
            }
            
        }
    }
    public var textColor:UIColor = UIColor.darkText
    public var tintFieldColor:UIColor = UIColor.red
    public var borderLineColor:UIColor = UIColor.black
    public var borderLineThickness:CGFloat = 1
    public var shouldSecureText:Bool = false
    public var fieldBackgroundColor:UIColor = UIColor.clear
    public var fieldCornerRadius:CGFloat = 5.0
    public var placeholder:String = ""

    public var style:SVPinViewStyle = .underline
    
    public var font:UIFont = UIFont.systemFont(ofSize: 16)
    public var keyboardType:UIKeyboardType = UIKeyboardType.numberPad
    public var pinIinputAccessoryView:UIView = UIView()
    public var becomeFirstResponderAtIndex:Int? = 0
    
    fileprivate var password = [String]()
    public var didFinishCallback: ((String)->())?
    public var didChangeCallback: ((String)->())?
    
    fileprivate var view:UIView!
    fileprivate var reuseIdentifier = "SVPinCell"
    fileprivate var isLoading = true

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    private func loadView() {
        let podBundle = Bundle(for: SVPinView.self)
        let nib = UINib(nibName: "SVPinView", bundle: podBundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        
        password.removeAll()
        for _ in 0 ..< pinLength {
            password.append("")
        }
        
        // for CollectionView
        let collectionViewNib = UINib(nibName: "SVPinCell", bundle:podBundle)
        collectionView.register(collectionViewNib, forCellWithReuseIdentifier: reuseIdentifier)
        //flowLayout.scrollDirection = .vertical //weird!!!
        collectionView.isScrollEnabled = false

        self.addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    }
    
    @objc fileprivate func textFieldDidChange(_ textField: UITextField) {
        var nextTag = textField.tag
        let index = nextTag - 100
        let placeholderLabel = textField.superview?.viewWithTag(400) as! UILabel
        
        // ensure single character in text box and trim spaces
        if textField.text!.count > 1 {
            textField.text?.removeFirst()
            textField.text = { () -> String in
                let text = textField.text ?? ""
                return String(text[..<text.index((text.startIndex), offsetBy: 1)])
            }()
            textField.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0)
        }
        
        let isBackSpace = { () -> Bool in
            let char = textField.text!.cString(using: String.Encoding.utf8)!
            return strcmp(char, "\\b") == -92
        }
        
        if !isBackSpace() && textField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return
        }
        
        // check if entered text is a backspace
        nextTag = isBackSpace() ? textField.tag - 1 : textField.tag + 1
        
        // Try to find next responder
        if let nextResponder = textField.superview?.superview?.superview?.superview?.viewWithTag(nextTag) as UIResponder? {
            nextResponder.becomeFirstResponder()  // Found next responder, so set it.
        } else {
            let shouldDismissKeyboardOnEmptyFirstField = false
            // Not found, so dismiss keyboard
            if index == 1 && shouldDismissKeyboardOnEmptyFirstField {
                textField.resignFirstResponder()
            } else if index > 1 { textField.resignFirstResponder() }
        }
        
        // activate the placeholder if textField empty
        placeholderLabel.isHidden = !textField.text!.isEmpty
        
        // secure text after a bit
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            if textField.text == "" {
                textField.text = " "
                placeholderLabel.isHidden = false
                textField.layer.sublayerTransform = CATransform3DMakeTranslation(-4, 0, 0)
            } else {
                placeholderLabel.isHidden = true
                if self.shouldSecureText { textField.text = self.secureCharacter } else {}
            }
        })
        
        // store text
        let text =  textField.text ?? ""
        let passwordIndex = index - 1
        // delete if space
        password[passwordIndex] = text == " " ? "" : text
        validateAndSendCallback()
    }
    
    private func validateAndSendCallback() {
        didChangeCallback?(password.joined())
        
        let pin = getPin()
        guard !pin.isEmpty else {return}
        if didFinishCallback != nil {
            didFinishCallback!(pin)
        }
    }
    
    fileprivate func setPlaceholder() {
        for (index,char) in placeholder.enumerated() {
            guard index < pinLength else {return}
            
            let placeholderLabel = collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.viewWithTag(400) as! UILabel
            placeholderLabel.text = String(char)
        }
    }
    
    // MARK: Public methods
    @objc
    public func getPin() -> String {
        
        guard !isLoading else {return ""}
        
        guard password.count == pinLength && password.joined().trimmingCharacters(in: CharacterSet(charactersIn: " ")).count == pinLength else {
            print("")
            return ""
        }
        return password.joined()
    }
    
    @objc
    public func clearPin() {
        
        guard !isLoading else {return}
        
        password.removeAll()
        self.view.removeFromSuperview()
        isLoading = true
        loadView()
    }
    
    @objc
    public func pastePin(pin:String) {
        
        password = []
        
        for (index,char) in pin.enumerated() {
            
            guard index < pinLength else {return}
            
            //Get the first textField
            let textField = collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.viewWithTag(101 + index) as! SVPinField
            let placeholderLabel = collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.viewWithTag(400) as! UILabel

            textField.text = String(char)
            placeholderLabel.isHidden = true
            
            //secure text after a bit
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                if textField.text == "" {
                    textField.text = " "
                    placeholderLabel.isHidden = false
                } else {
                    if self.shouldSecureText {textField.text = self.secureCharacter} else {}
                }
            })
            
            // store text
            password.append(String(char))
            validateAndSendCallback()
        }
    }
}
extension SVPinView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pinLength
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let textField = cell.viewWithTag(100) as! SVPinField
        let containerView = cell.viewWithTag(51)!
        let underLine = cell.viewWithTag(50)!
        let placeholderLabel = cell.viewWithTag(400) as! UILabel

        // Setting up textField
        textField.tag = 101 + indexPath.row
        if textField.tag == 101 {
            textField.text =  ""
        }else{
            textField.text =  " "
        }
        textField.autocorrectionType = .yes
        textField.spellCheckingType = .yes
        textField.smartInsertDeleteType = .yes
        textField.isSecureTextEntry = false
        textField.textColor = self.textColor
        textField.tintColor = self.tintFieldColor
        textField.font = self.font
        textField.keyboardType = self.keyboardType
        textField.inputAccessoryView = self.pinIinputAccessoryView
                
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        placeholderLabel.text = ""
        placeholderLabel.textColor = self.textColor.withAlphaComponent(0.5)
        
        
        if indexPath.row == 0{
            if #available(iOS 12.0, *) {
                textField.textContentType = UITextContentType.oneTimeCode
            } else {
                textField.textContentType = nil
            }
        }else{
            textField.textContentType = nil
        }
        
        containerView.backgroundColor = fieldBackgroundColor
        containerView.layer.cornerRadius = fieldCornerRadius
        
        func setupUnderline(color:UIColor, withThickness thickness:CGFloat) {
            underLine.backgroundColor = color
            underLine.constraints.filter { (constraint) -> Bool in
                return constraint.identifier == "underlineHeight"
                }.first?.constant = thickness
        }
        
        switch style {
        case .none:
            setupUnderline(color: UIColor.clear, withThickness: 0)
            containerView.layer.borderWidth = 0
            containerView.layer.borderColor = UIColor.clear.cgColor
        case .underline:
            //setupUnderline(color: borderLineColor, withThickness: borderLineThickness)
            setupUnderline(color: UIColor.clear, withThickness: 0)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                textField.bottomLine(color: self.borderLineColor)
            }
            containerView.layer.borderWidth = 0
            containerView.layer.borderColor = UIColor.clear.cgColor
        case .box:
            setupUnderline(color: UIColor.clear, withThickness: 0)
            containerView.layer.borderWidth = borderLineThickness
            containerView.layer.borderColor = borderLineColor.cgColor
        }
        
        // Make the Pin field the first responder
        if let firstResponderIndex = becomeFirstResponderAtIndex, firstResponderIndex == indexPath.item {
            textField.becomeFirstResponder()
        }
        
        // Finished loading pinView
        if indexPath.row == pinLength - 1 && isLoading {
            isLoading = false
            DispatchQueue.main.async {
                if !self.placeholder.isEmpty {self.setPlaceholder()}
            }
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            let width = (collectionView.bounds.width - (interSpace * CGFloat(max(pinLength, 1) - 1)))/CGFloat(pinLength)
            return CGSize(width: width, height: collectionView.frame.height)
        }
        /*
        let width = (collectionView.bounds.width - (interSpace * CGFloat(max(pinLength, 1) - 1)))/CGFloat(pinLength)
        let height = collectionView.frame.height
        return CGSize(width: min(width, height), height: min(width, height))
         */
        return CGSize(width: cellSize, height: view.height)
    }
        
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interSpace
    }
    /*
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        let width = (collectionView.bounds.width - (interSpace * CGFloat(max(pinLength, 1) - 1)))/CGFloat(pinLength)
        let height = collectionView.frame.height
        let top = (collectionView.bounds.height - min(width, height)) / 2
        if height < width {
            // If width of field > height, size the fields to the pinView height and center them.
            let totalCellWidth = height * CGFloat(pinLength)
            let totalSpacingWidth = interSpace * CGFloat(max(pinLength, 1) - 1)
            let inset = (collectionView.frame.size.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
            return UIEdgeInsets(top: top, left: inset, bottom: 0, right: inset)
        }
        return UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
    }
    
    public override func layoutSubviews() {
        flowLayout.invalidateLayout()
    }
   */
}
extension SVPinView : UITextFieldDelegate
{
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        let text = textField.text!
        let placeholderLabel = textField.superview?.viewWithTag(400) as! UILabel
        placeholderLabel.isHidden = true

        if text.count == 0 {
            textField.isSecureTextEntry = false
            if textField.tag == 101 {
                textField.text =  ""
            }else{
                textField.text =  " "
            }
            placeholderLabel.isHidden = false
        }
        
        if style == .underline {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                textField.bottomLine(color: self.tintFieldColor)
            }
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if style == .underline {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                textField.bottomLine(color: self.borderLineColor)
            }
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == UIPasteboard.general.string {
            textField.resignFirstResponder()
            DispatchQueue.main.async {
                self.pastePin(pin: string)
            }
            return false
        }
        return true
    }
}
