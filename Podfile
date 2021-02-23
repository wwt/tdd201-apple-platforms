workspace 'TDD-201'

inhibit_all_warnings!


target 'DependencyInjection' do
  platform :macos, '10.15'
  project 'DependencyInjection/DependencyInjection.xcodeproj'
  use_frameworks!

  pod 'RealmSwift'

  target 'DependencyInjectionTests' do

  end
end































target 'MockingFramework' do
  platform :ios, '11.0'
  project 'MockingFramework/MockingFramework.xcodeproj'
  use_frameworks!
  
  target 'MockingFrameworkTests' do

  end
end

target 'WriteToFile' do
  platform :ios, '11.0'
  project 'WriteToFile/WriteToFile.xcodeproj'
  use_frameworks!
  
  pod 'Swinject'
  
  target 'WriteToFileTests' do

  end
end

target 'WriteToUserDefaults' do
  platform :ios, '11.0'
  project 'WriteToUserDefaults/WriteToUserDefaults.xcodeproj'
  use_frameworks!

  target 'WriteToUserDefaultsTests' do

  end
end

target 'CombineWithREST' do
  platform :ios, '11.0'
  project 'CombineWithREST/CombineWithREST.xcodeproj'
  use_frameworks!
  
  target 'CombineWithRESTTests' do

  end
end

target 'ContractTesting' do
  platform :ios, '11.0'
  project 'ContractTesting/ContractTesting.xcodeproj'
  use_frameworks!
  
  target 'ContractTestingTests' do

  end
end

target 'HTTPStubbing' do
  platform :ios, '11.0'
  project 'HTTPStubbing/HTTPStubbing.xcodeproj'
  use_frameworks!
  
  target 'HTTPStubbingTests' do

  end
  
end

target 'UIKitWithStoryboard' do
  platform :ios, '11.0'
  project 'UIKitWithStoryboard/UIKitWithStoryboard.xcodeproj'
  use_frameworks!

  target 'UIKitWithStoryboardTests' do

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
