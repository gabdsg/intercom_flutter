#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'intercom_flutter'
  s.version          = '3.0.0'
  s.summary          = 'Intercom integration for Flutter'
  s.description      = <<-DESC
  Flutter plugin for Intercom integration. Provides in-app messaging
  and help-center Intercom services
                       DESC
  s.homepage         = 'https://github.com/gabdsg'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'gabdsg' => 'gabriel@uruworks.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Intercom'
  s.static_framework = true
  s.dependency 'Intercom', '~> 7.1.2'
  s.ios.deployment_target = '10.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end

