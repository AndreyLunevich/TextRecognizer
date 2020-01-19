use_frameworks!
inhibit_all_warnings!

target 'TextRecognizer' do
  platform :ios, '12.0'

  pod 'SwiftOCR', :git => 'https://github.com/AndreyLunevich/SwiftOCR.git'
  pod 'SQLite.swift'

  target 'TextRecognizerTests' do
      inherit! :search_paths

      pod 'Quick', '~> 2.0'
      pod 'Nimble', '~> 8.0'
  end

end
