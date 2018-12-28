# SwiftMaskTextfield

SwiftMaskTextfield inherits from UITextField for supporting masks into textfields that can be defined into the storyboard

* Lightweight implementation
* Can be used with or without masks
* Ability to override de formatting function to create custom implemantion of the class
* The replaceable characters from the mask format can be changed by overriding them
* Supports spaces, dots and any special chars on the format, for instance: "####.### ###" 

### How to use
* Install with cocoapods or copy the class SwiftMaskTextfield into your project
* Add a UITextfield component into your storyboard or xib
* Set it's custom class to SwiftMaskTextfield
* Set the formatting mask into the property formatPattern in Interface Builder or programattically 

| Characters | Format replacement |
|:------------:|:------------------------------:|
| letters and digits | __*__ |
| any letter | __@__ |
| lowercase letters | __a__ |
| uppercase letters | __A__ |
| digits | __#__ | 

### (1.1.0) 
* Added support for adding a prefix on the resulting string, works the same as before, just set the prefix on the storyboard or through code and the lib will take care of the rest
