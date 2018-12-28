Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "SwiftMaskTextfield"
  s.version      = "1.1.0"
  s.summary      = "An TextField with masking capabilities"

  s.description  = <<-DESC
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

                   DESC

  s.homepage     = "https://github.com/gabriel-kozma/swift-mask-textfield"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = { :type => "MIT", :file => "LICENSE.md" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "Gabriel Kozma" => "gabrielmackoz@gmail.com" }
  s.social_media_url   = "https://www.linkedin.com/in/gabriel-maccori-kozma-4b3b1032"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "9.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/gabriel-kozma/swift-mask-textfield.git", :tag => "#{s.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "swift-mask-textfield/**/*.{swift}"
end
