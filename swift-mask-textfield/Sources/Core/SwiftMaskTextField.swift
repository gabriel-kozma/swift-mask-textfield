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

public class SwiftMaskTextField : UITextField {
    
//**************************************************
// MARK: - Properties
//**************************************************
    
    public let lettersAndDigitsReplacementChar: String = "*"
    public let anyLetterReplecementChar: String = "@"
    public let lowerCaseLetterReplecementChar: String = "a"
    public let upperCaseLetterReplecementChar: String = "A"
    public let digitsReplecementChar: String = "#"
    
    /**
     Var that holds the format pattern that you wish to apply
     to some text
     
     If the pattern is set to "" no mask would be applied and
     the textfield would behave like a normal one
     */
    @IBInspectable public var formatPattern: String = ""
    
    /**
     Var that have the maximum length, based on the mask set
     */
    public var maxLength: Int {
        get {
            return formatPattern.characters.count
        }
    }
    
    /**
     Overriding the var text from UITextField so if any text
     is applied programmatically by calling formatText
     */
    override public var text: String? {
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
    
    private func setup() {
        self.registerForNotifications()
    }
    
    private func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(textDidChange),
                                                         name: "UITextFieldTextDidChangeNotification",
                                                         object: self)
    }
    
    private func deRegisterForNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc private func textDidChange() {
        self.undoManager?.removeAllActions()
        self.formatText()
    }
    
    private func getOnlyDigitsString(string: String) -> String {
        let charactersArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        return charactersArray.joinWithSeparator("")
    }
    
    private func getOnlyLettersString(string: String) -> String {
        let charactersArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacterSet().invertedSet)
        return charactersArray.joinWithSeparator("")
    }
    
    private func getUppercaseLettersString(string: String) -> String {
        let charactersArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet.uppercaseLetterCharacterSet().invertedSet)
        return charactersArray.joinWithSeparator("")
    }
    
    private func getLowercaseLettersString(string: String) -> String {
        let charactersArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet.lowercaseLetterCharacterSet().invertedSet)
        return charactersArray.joinWithSeparator("")
    }
    
    private func getFilteredString(string: String) -> String {
        let charactersArray = string.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        return charactersArray.joinWithSeparator("")
    }
    
//**************************************************
// MARK: - Self Public Methods
//**************************************************
    
    /**
     Func that formats the text based on formatPattern
     
     Override this function if you want to customize the behaviour of 
     the class
     */
    public func formatText() {
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
                    let formatPatternRange = formatterIndex ..< formatterIndex.advancedBy(1)
                    let currentFormatCharacter = self.formatPattern.substringWithRange(formatPatternRange)
                    
                    let currentTextForFormattingPatterRange = currentTextForFormattingIndex ..< currentTextForFormattingIndex.advancedBy(1)
                    let currentTextForFormattingCharacter = currentTextForFormatting.substringWithRange(currentTextForFormattingPatterRange)
                    
                    switch currentFormatCharacter {
                        case self.lettersAndDigitsReplacementChar:
                            finalText += currentTextForFormattingCharacter
                            currentTextForFormattingIndex = currentTextForFormattingIndex.successor()
                        case self.anyLetterReplecementChar:
                            let filteredChar = self.getOnlyLettersString(currentTextForFormattingCharacter)
                            finalText += filteredChar
                            currentTextForFormattingIndex = currentTextForFormattingIndex.successor()
                        case self.lowerCaseLetterReplecementChar:
                            let filteredChar = self.getLowercaseLettersString(currentTextForFormattingCharacter)
                            finalText += filteredChar
                            currentTextForFormattingIndex = currentTextForFormattingIndex.successor()
                        case self.upperCaseLetterReplecementChar:
                            let filteredChar = self.getUppercaseLettersString(currentTextForFormattingCharacter)
                            finalText += filteredChar
                            currentTextForFormattingIndex = currentTextForFormattingIndex.successor()
                        case self.digitsReplecementChar:
                            let filteredChar = self.getOnlyDigitsString(currentTextForFormattingCharacter)
                            finalText += filteredChar
                            currentTextForFormattingIndex = currentTextForFormattingIndex.successor()
                        default:
                            finalText += currentFormatCharacter
                    }
                    
                    formatterIndex = formatterIndex.successor()
                    
                    if formatterIndex >= self.formatPattern.endIndex ||
                        currentTextForFormattingIndex >= currentTextForFormatting.endIndex {
                        break
                    }
                }
            }
            super.text = finalText
            
            if let text = self.text {
                if text.characters.count > self.maxLength {
                    super.text = text.substringToIndex(text.startIndex.advancedBy(self.maxLength))
                }
            }
        }
    }
}