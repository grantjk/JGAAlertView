Pod::Spec.new do |s|
  s.name         = "JGAAlertView"
  s.version      = "0.0.1"
  s.summary      = "Block based alert views."
  s.license      = 'MIT'
  s.homepage     = "https://github.com/grantjk/JGAAlertView"
  s.author       = { "John Grant" => "johnkgrant@gmail.com" }
  s.source       = { :git => "https://github.com/grantjk/JGAAlertView.git", commit: '41f8dad94a7d9db33966bafe3dc1427115ba185d' }
  s.platform     = :ios, '5.0'
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end
