Pod::Spec.new do |s|
  s.name     = 'JGAAlertView'
  s.version  = '1.0.1'
  s.license  = 'MIT'
  s.summary  = 'Block based alert view.'
  s.homepage = 'https://github.com/grantjk/JGAAlertView'
  s.authors  = {'John Grant' => 'johnkgrant@gmail.com' }
  s.source   = { :git => 'https://github.com/grantjk/JGAAlertView.git', tag: s.version }
  s.source_files = '*.{h,m}'
  s.platform     = :ios
  s.requires_arc = true
end
