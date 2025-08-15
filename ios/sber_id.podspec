Pod::Spec.new do |s|
  s.name             = 'sber_id'
  s.version          = '0.0.1+1'
  s.summary          = 'Sber ID authentication plugin for Flutter.'
  s.description      = <<-DESC
Flutter plugin for Sber ID authentication with automatic SDK optimization.
Uses dynamic SIDSDK for better performance, falls back to static when needed.
                       DESC
  s.homepage         = 'https://github.com/nurullohabduvohidov/sber_id'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Nurulloh' => 'nabduvahed@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'

  begin
    s.dependency 'SIDSDK', '~> 1.6.0'
    s.static_framework = false
    puts "✅ Sber ID: Using dynamic SIDSDK for optimal performance"
  rescue
    s.dependency 'SIDSDKStatic', '~> 1.6.0'
    s.static_framework = true
    puts "📦 Sber ID: Using static SDK for compatibility"
  end

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    'OTHER_LDFLAGS' => '-ObjC'
  }
end