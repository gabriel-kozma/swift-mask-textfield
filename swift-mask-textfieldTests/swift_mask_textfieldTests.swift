//
//  swift_mask_textfieldTests.swift
//  swift-mask-textfieldTests
//
//  Created by Gabriel Kozma on 9/7/16.
//  Copyright © 2016 gabrielmackoz. All rights reserved.
//

import XCTest
import SwiftMaskTextField

class swift_mask_textfieldTests: XCTestCase {
    
    let textField = SwiftMaskTextfield(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    func testTextField_WithDigitsOnlyFormatPatternAndValidate_ShouldSucceed() {
        self.measure {
            self.textField.formatPattern = "#####.#####  #####.#####"
            self.textField.text = "01234567890123456789"
            
            XCTAssertEqual(self.textField.text, "01234.56789  01234.56789")
        }
    }

    func testTextField_WithLettersOnlyFormatPatternAndValidate_ShouldSucceed() {
        self.measure {
            self.textField.formatPattern = "@@@@@.@@@@@"
            self.textField.text = "abcdeABCDE"
        
            XCTAssertEqual(self.textField.text, "abcde.ABCDE")
        }
    }
    
    func testTextField_WithLowercaseLettersOnlyFormatPatternAndValidate_ShouldSucceed() {
        self.measure {
            self.textField.formatPattern = "aaaaa.aaaaa"
            self.textField.text = "abcdeABCDEabcde"
            
            XCTAssertEqual(self.textField.text, "abcde.abcde")
        }
    }
    
    func testTextField_WithUppercaseLettersOnlyFormatPatternAndValidate_ShouldSucceed() {
        self.measure {
            self.textField.formatPattern = "AAAAA.AAAAA"
            self.textField.text = "abcdeABCDEabcdeABCDE"
            
            XCTAssertEqual(self.textField.text, "ABCDE.ABCDE")
        }
    }
    
    func testTextField_WithCustomFormatPatternAndValidate_ShouldSucceed() {
        self.measure {
            self.textField.formatPattern = "#Aa@*.#Aa@*"
            self.textField.text = "AfaaGA125GA1ab51c521d5e5ABFAC52FA1DEAFaAFAb521cde521ABCDE"
            
            XCTAssertEqual(self.textField.text, "1Gab5.1AaAF")
        }
    }
}
