Pod::Spec.new do |s|
  s.name             = 'sber_id'
  s.version          = '0.0.1'
  s.summary          = 'Sber ID authentication plugin for Flutter.'
  s.description      = <<-DESC
A Flutter plugin for Sber ID authentication on iOS and Android platforms.
                       DESC
  s.homepage         = 'https://pub.dev/packages/sber_id'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Nurulloh' => 'nabduvahed@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'SIDSDKStatic', '~> 1.4.0'
  s.platform = :ios, '13.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end