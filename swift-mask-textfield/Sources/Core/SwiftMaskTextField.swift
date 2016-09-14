/*
 * MIT License
 *
 * Copyright (c) 2016 Gabriel Maccori Kozma
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import UIKit

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

open class SwiftMaskTextField : UITextField {
    
//**************************************************
// MARK: - Properties
//**************************************************
    
    open let lettersAndDigitsReplacementChar: String = "*"
    open let anyLetterReplecementChar: String = "@"
    open let lowerCaseLetterReplecementChar: String = "a"
    open let upperCaseLetterReplecementChar: String = "A"
    open let digitsReplecementChar: String = "#"
    
    /**
     Var that holds the format pattern that you wish to apply
     to some text
     
     If the pattern is set to "" no mask would be applied and
     the textfield would behave like a normal one
     */
    @IBInspectable open var formatPattern: String = ""
    
    /**
     Var that have the maximum length, based on the mask set
     */
    open var maxLength: Int {
        get {
            return formatPattern.characters.count
        }
    }
    
    /**
     Overriding the var text from UITextField so if any text
     is applied programmatically by calling formatText
     */
    override open var text: String? {
        set {
            super.text = newValue
            self.formatText()
        }
        
        get {
            return super.text
        }
    }
    
//**************************************************
// MARK: - Constructors
//**************************************************
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    deinit {
        self.deRegisterForNotifications()
    }
    
//**************************************************
// MARK: - Private Methods
//**************************************************
    
    fileprivate func setup() {
        self.registerForNotifications()
    }
    
    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(textDidChange),
                                             name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"),
                                             object: self)
    }
    
    fileprivate func deRegisterForNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func textDidChange() {
        self.undoManager?.removeAllActions()
        self.formatText()
    }
    
    fileprivate func getOnlyDigitsString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return charactersArray.joined(separator: "")
    }
    
    fileprivate func getOnlyLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.letters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    fileprivate func getUppercaseLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.uppercaseLetters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    fileprivate func getLowercaseLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.lowercaseLetters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    fileprivate func getFilteredString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.alphanumerics.inverted)
        return charactersArray.joined(separator: "")
    }
    
//**************************************************
// MARK: - Self Public Methods
//**************************************************
    
    /**
     Func that formats the text based on formatPattern
     
     Override this function if you want to customize the behaviour of 
     the class
     */
    open func formatText() {
        var currentTextForFormatting = ""
        
        if let text = super.text {
            if text.characters.count > 0 {
                currentTextForFormatting = text
            }
        }
        
        if self.maxLength > 0 {
            var formatterIndex = self.formatPattern.startIndex, currentTextForFormattingIndex = currentTextForFormatting.startIndex
            var finalText = ""
            
            currentTextForFormatting = self.getFilteredString(currentTextForFormatting)
            
            if currentTextForFormatting.characters.count > 0 {
                while true {
                    let formatPatternRange = formatterIndex ..< formatPattern.index(after: formatterIndex)
                    let currentFormatCharacter = self.formatPattern.substring(with: formatPatternRange)
                    
                    let currentTextForFormattingPatterRange = currentTextForFormattingIndex ..< currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    let currentTextForFormattingCharacter = currentTextForFormatting.substring(with: currentTextForFormattingPatterRange)
                    
                    switch currentFormatCharacter {
                        case self.lettersAndDigitsReplacementChar:
                            finalText += currentTextForFormattingCharacter
                            currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        case self.anyLetterReplecementChar:
                            let filteredChar = self.getOnlyLettersString(currentTextForFormattingCharacter)
                            if !filteredChar.isEmpty {
                                finalText += filteredChar
                                formatterIndex = formatPattern.index(after: formatterIndex)
                            }
                            currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                        case self.lowerCaseLetterReplecementChar:
                            let filteredChar = self.getLowercaseLettersString(currentTextForFormattingCharacter)
                            if !filteredChar.isEmpty {
                                finalText += filteredChar
                                formatterIndex = formatPattern.index(after: formatterIndex)
                            }
                            currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                        case self.upperCaseLetterReplecementChar:
                            let filteredChar = self.getUppercaseLettersString(currentTextForFormattingCharacter)
                            if !filteredChar.isEmpty {
                                finalText += filteredChar
                                formatterIndex = formatPattern.index(after: formatterIndex)
                            }
                            currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                        case self.digitsReplecementChar:
                            let filteredChar = self.getOnlyDigitsString(currentTextForFormattingCharacter)
                            if !filteredChar.isEmpty {
                                finalText += filteredChar
                                formatterIndex = formatPattern.index(after: formatterIndex)
                            }
                            currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                        default:
                            finalText += currentFormatCharacter
                            formatterIndex = formatPattern.index(after: formatterIndex)
                    }
                    
                    if formatterIndex >= self.formatPattern.endIndex ||
                        currentTextForFormattingIndex >= currentTextForFormatting.endIndex {
                        break
                    }
                }
            }
            super.text = finalText
            
            if let text = self.text {
                if text.characters.count > self.maxLength {
                    super.text = text.substring(to: text.characters.index(text.startIndex, offsetBy: self.maxLength))
                }
            }
        }
    }
}
