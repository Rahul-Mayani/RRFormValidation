import Foundation

public struct Validation {
    public var minimumLength = 0
    public var maximumLength: Int?
    public var maximumValue: Double?
    public var minimumValue: Double?
    public var characterSet: CharacterSet?
    public var format: String?

    public init() {}

    // Making complete false will cause minimumLength, minimumValue and format to be ignored
    // this is useful for partial validations, or validations where the final string is
    // in process of been completed. For example when entering characters into an UITextField
    public func validateString(_ string: String, complete: Bool = true) -> Bool {
        var valid = true

        if complete {
            valid = (string.count >= minimumLength)
        }

        if valid {
            if let maximumLength = self.maximumLength {
                valid = (string.count <= maximumLength)
            }
        }

        if valid {
            let formatter = NumberFormatter()
            let number = formatter.number(from: string)
            if let number = number {
                if let maximumValue = self.maximumValue {
                    valid = (number.doubleValue <= maximumValue)
                }

                if valid && complete {
                    if let minimumValue = self.minimumValue {
                        valid = (number.doubleValue >= minimumValue)
                    }
                }
            }
        }

        if valid {
            if let characterSet = self.characterSet {
                let stringCharacterSet = CharacterSet(charactersIn: string)
                valid = characterSet.isSuperset(of: stringCharacterSet)
            }
        }

        if valid && complete {
            if let format = self.format {
                let regex = try! NSRegularExpression(pattern: format, options: .caseInsensitive)
                let range = regex.rangeOfFirstMatch(in: string, options: .reportProgress, range: NSRange(location: 0, length: string.count))
                valid = (range.location == 0 && range.length == string.count)
            }
        }

        return valid
    }
}

public struct CardTypeValidation {
    
    static func matchesRegex(regex: String!, text: String!) -> Bool {
        
        let textRemovalWhiteSpace = text.replacingOccurrences(of: " ", with: "", options: .regularExpression)
        let regex = NSPredicate(format:"SELF MATCHES %@", regex)
        return regex.evaluate(with: textRemovalWhiteSpace)
    }
}

enum CardType: String {
    case Unknown, Amex, Visa, Mastercard, Diners, Discover, JCB, UnionPay
    
    static let allCards = [Amex, Visa, Mastercard, Diners, Discover, JCB, UnionPay, Unknown]
    
    var regexType : String {
        switch self {
        case .Amex:
            return "^3[47][0-9]{5,}$"
        case .Visa:
            return "^4[0-9]{6,}([0-9]{3})?$"
        case .Mastercard:
            return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Diners:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPay:
            return "^(62|88)[0-9]{5,}$"
        default:
            return ""
        }
    }
    
    var name: String {
        if self == .Amex {
            return "American Express"
        } else {
            return self.rawValue
        }
    }
}

