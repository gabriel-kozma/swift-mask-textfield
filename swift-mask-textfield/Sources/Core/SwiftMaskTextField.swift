//
//  SwiftMaskTextField.swift
//  swift-mask-textfield
//
//  Created by Gabriel Kozma on 9/7/16.
//  Copyright © 2016 gabrielmackoz. All rights reserved.
//

import UIKit

public class SwiftMaskTextField : UITextField {
    
    public let lettersAndDigitsReplacementChar: String = "*"
    public let anyLetterReplecementChar: String = "@"
    public let lowerCaseLetterReplecementChar: String = "a"
    public let upperCaseLetterReplecementChar: String = "A"
    public let digitsReplecementChar: String = "#"
    
    @IBInspectable public var formatPattern: String = ""
    
    public var maxLength: Int {
        get {
            return formatPattern.characters.count
        }
    }
    
    override public var text: String? {
        set {
            super.text = newValue
            self.formatText()
        }
        
        get {
            return super.text
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
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
        }
        
        if self.maxLength > 0 {
            if let text = self.text {
                if text.characters.count > self.maxLength {
                    super.text = text.substringToIndex(text.startIndex.advancedBy(self.maxLength))
                }
            }
        }
        
    }
    
    deinit {
        self.deRegisterForNotifications()
    }
}