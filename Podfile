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
