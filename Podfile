workspace 'TDD-201'

platform :ios, '11.0'
inhibit_all_warnings!

target 'MockingFramework' do
    project 'MockingFramework/MockingFramework.xcodeproj'
    use_frameworks!

    target 'MockingFrameworkTests' do
        pod 'Cuckoo'
    end
end

target 'WriteToUserDefaults' do
    project 'WriteToUserDefaults/WriteToUserDefaults.xcodeproj'
    use_frameworks!

    pod 'Swinject'
    
    target 'WriteToUserDefaultsTests' do
        pod 'Cuckoo'
        pod 'Cuckoo/OCMock'
    end
end

target 'DependencyInjection' do
    project 'DependencyInjection/DependencyInjection.xcodeproj'
    use_frameworks!

    pod 'Swinject'
    
    target 'DependencyInjectionTests' do
        pod 'Cuckoo'
    end
end

target 'CombineWithREST' do
  project 'CombineWithREST/CombineWithREST.xcodeproj'
  use_frameworks!

  pod 'Swinject'
  
  target 'CombineWithRESTTests' do
    pod 'OHHTTPStubs/Swift'
    pod 'Cuckoo'
    pod 'Fakery'
  end
end

target 'ContractTesting' do
  project 'ContractTesting/ContractTesting.xcodeproj'
  use_frameworks!
  
  target 'ContractTestingTests' do
    pod 'OHHTTPStubs/Swift'
    pod 'PactConsumerSwift'
    pod 'Fakery'
  end
end

target 'HTTPStubbing' do
  project 'HTTPStubbing/HTTPStubbing.xcodeproj'
  use_frameworks!

  target 'HTTPStubbingTests' do
    pod 'OHHTTPStubs/Swift'
  end
  
end
