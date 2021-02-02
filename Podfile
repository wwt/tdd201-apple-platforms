workspace 'TDD-201'

inhibit_all_warnings!

target 'MockingFramework' do
  platform :ios, '11.0'
  project 'MockingFramework/MockingFramework.xcodeproj'
  use_frameworks!
  
  target 'MockingFrameworkTests' do
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
  end
end

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

target 'HTTPStubbing' do
  platform :ios, '11.0'
  project 'HTTPStubbing/HTTPStubbing.xcodeproj'
  use_frameworks!
  
  target 'HTTPStubbingTests' do
    pod 'OHHTTPStubs/Swift'
  end
  
end
