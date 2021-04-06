workspace 'TDD-201'

inhibit_all_warnings!

target 'ContractTesting' do
  platform :ios, '11.0'
  project 'ContractTesting/ContractTesting.xcodeproj'
  use_frameworks!

  target 'ContractTestingTests' do
    pod 'OHHTTPStubs/Swift'
    pod 'PactConsumerSwift'
    pod 'Fakery'
  end
end

target 'MockingFramework' do
  platform :ios, '11.0'
  project 'MockingFramework/MockingFramework.xcodeproj'
  use_frameworks!
  
  target 'MockingFrameworkTests' do
    pod 'Cuckoo'
  end
end

target 'WriteToFile' do
  platform :ios, '11.0'
  project 'WriteToFile/WriteToFile.xcodeproj'
  use_frameworks!
  
  pod 'Swinject'
  
  target 'WriteToFileTests' do
    pod 'Cuckoo'
  end
end

target 'WriteToUserDefaults' do
  platform :ios, '11.0'
  project 'WriteToUserDefaults/WriteToUserDefaults.xcodeproj'
  use_frameworks!
  
  pod 'Swinject'
  
  target 'WriteToUserDefaultsTests' do
    pod 'Cuckoo/OCMock'
  end
end

target 'DependencyInjection' do
  platform :macos, '10.15'
  project 'DependencyInjection/DependencyInjection.xcodeproj'
  use_frameworks!
  
  pod 'Swinject'
  pod 'RealmSwift'
  
  target 'DependencyInjectionTests' do
    
  end
end

target 'CombineWithREST' do
  platform :ios, '11.0'
  project 'CombineWithREST/CombineWithREST.xcodeproj'
  use_frameworks!
  
  pod 'Swinject'
  
  target 'CombineWithRESTTests' do
    pod 'OHHTTPStubs/Swift'
    pod 'Cuckoo'
    pod 'Fakery'
    pod 'PactConsumerSwift'
    pod 'UIUTest'
  end
end

target 'HTTPStubbing' do
  platform :ios, '11.0'
  project 'HTTPStubbing/HTTPStubbing.xcodeproj'
  use_frameworks!
  
  target 'HTTPStubbingTests' do
    pod 'OHHTTPStubs/Swift'
  end
  
end

target 'UIKitWithStoryboard' do
  platform :ios, '11.0'
  project 'UIKitWithStoryboard/UIKitWithStoryboard.xcodeproj'
  use_frameworks!
  pod 'Swinject'

  target 'UIKitWithStoryboardTests' do
    pod 'UIUTest'
    pod 'Cuckoo'
    pod 'Cuckoo/OCMock'
    pod 'Fakery'
  end

end

target 'SwiftUIExample' do
  platform :ios, '13.0'
  project 'SwiftUIExample/SwiftUIExample.xcodeproj'
  use_frameworks!
  pod 'Swinject'

  target 'SwiftUIExampleTests' do
    pod 'ViewInspector'
    pod 'Fakery'
    pod 'OHHTTPStubs/Swift'
    pod 'Cuckoo'
    pod 'PactConsumerSwift'
  end

  target 'SwiftUIExampleUITests' do
#    pod 'Swinject'
  end

  target 'WatchLandmarks' do
    platform :watchos, '7.2'
    pod 'Swinject'
  end

  target 'WatchLandmarks Extension' do
    platform :watchos, '7.2'
    pod 'Swinject'
  end
end

target 'MutationTesting' do
  project 'MutationTesting/MutationTesting.xcodeproj'
  pod 'SwiftLint'
end

post_install do |installer|
  installer.aggregate_targets.each do |target|
    project = target.user_project
    project.targets.each do |target|
      next unless target.shell_script_build_phases.none? { |n| "Lint" == n.name  }
      phase = target.new_shell_script_build_phase("Lint")
      phase.shell_script = "${PODS_ROOT}/SwiftLint/swiftlint --config ../.swiftlint.yml"
    end

    project.save
  end
end
