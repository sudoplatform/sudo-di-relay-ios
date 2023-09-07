platform :ios, '15.0'

workspace 'SudoDIRelay'
use_frameworks!
inhibit_all_warnings!

project 'SudoDIRelay', {
    'Debug-Dev' => :debug,
    'Debug-QA' => :debug,
    'Debug-Prod' => :debug,
    'Release-Dev' => :release,
    'Release-QA' => :release,
    'Release-Prod' => :release
}

target 'SudoDIRelay' do
  inherit! :search_paths
  podspec :name => 'SudoDIRelay'

  target 'SudoDIRelayTests' do
    podspec :name => 'SudoDIRelay'
  end

  target 'SudoDIRelaySystemTests' do
    podspec :name => 'SudoDIRelay'
    pod 'SudoProfiles', '~> 17.0'
    pod 'SudoEntitlements', '~> 9.0.1'
    pod 'SudoEntitlementsAdmin', '~> 4.1.1'
  end
end

target 'TestApp' do
  inherit! :search_paths
  podspec :name => 'SudoDIRelay'
end

# Fix Xcode nagging warning on pod install/update
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
  end
end
