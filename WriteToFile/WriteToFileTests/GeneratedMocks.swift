// MARK: - Mocks generated from file: WriteToFileTests/TestFileManager.swift at 2021-02-02 20:42:42 +0000

//
//  TestFileManager.swift
//  WriteToFileTests
//
//  Created by Heather Meadow on 2/2/21.
//

import Cuckoo
@testable import WriteToFile

import Foundation


 class MockFileManager: FileManager, Cuckoo.ClassMock {
    
     typealias MocksType = FileManager
    
     typealias Stubbing = __StubbingProxy_FileManager
     typealias Verification = __VerificationProxy_FileManager

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: FileManager?

     func enableDefaultImplementation(_ stub: FileManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func contents(atPath path: String) -> Data? {
        
    return cuckoo_manager.call("contents(atPath: String) -> Data?",
            parameters: (path),
            escapingParameters: (path),
            superclassCall:
                
                super.contents(atPath: path)
                ,
            defaultCall: __defaultImplStub!.contents(atPath: path))
        
    }
    
    
    
     override func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]?) -> Bool {
        
    return cuckoo_manager.call("createFile(atPath: String, contents: Data?, attributes: [FileAttributeKey : Any]?) -> Bool",
            parameters: (path, data, attr),
            escapingParameters: (path, data, attr),
            superclassCall:
                
                super.createFile(atPath: path, contents: data, attributes: attr)
                ,
            defaultCall: __defaultImplStub!.createFile(atPath: path, contents: data, attributes: attr))
        
    }
    

	 struct __StubbingProxy_FileManager: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func contents<M1: Cuckoo.Matchable>(atPath path: M1) -> Cuckoo.ClassStubFunction<(String), Data?> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: path) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockFileManager.self, method: "contents(atPath: String) -> Data?", parameterMatchers: matchers))
	    }
	    
	    func createFile<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(atPath path: M1, contents data: M2, attributes attr: M3) -> Cuckoo.ClassStubFunction<(String, Data?, [FileAttributeKey : Any]?), Bool> where M1.MatchedType == String, M2.OptionalMatchedType == Data, M3.OptionalMatchedType == [FileAttributeKey : Any] {
	        let matchers: [Cuckoo.ParameterMatcher<(String, Data?, [FileAttributeKey : Any]?)>] = [wrap(matchable: path) { $0.0 }, wrap(matchable: data) { $0.1 }, wrap(matchable: attr) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockFileManager.self, method: "createFile(atPath: String, contents: Data?, attributes: [FileAttributeKey : Any]?) -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_FileManager: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func contents<M1: Cuckoo.Matchable>(atPath path: M1) -> Cuckoo.__DoNotUse<(String), Data?> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: path) { $0 }]
	        return cuckoo_manager.verify("contents(atPath: String) -> Data?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func createFile<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(atPath path: M1, contents data: M2, attributes attr: M3) -> Cuckoo.__DoNotUse<(String, Data?, [FileAttributeKey : Any]?), Bool> where M1.MatchedType == String, M2.OptionalMatchedType == Data, M3.OptionalMatchedType == [FileAttributeKey : Any] {
	        let matchers: [Cuckoo.ParameterMatcher<(String, Data?, [FileAttributeKey : Any]?)>] = [wrap(matchable: path) { $0.0 }, wrap(matchable: data) { $0.1 }, wrap(matchable: attr) { $0.2 }]
	        return cuckoo_manager.verify("createFile(atPath: String, contents: Data?, attributes: [FileAttributeKey : Any]?) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class FileManagerStub: FileManager {
    

    

    
     override func contents(atPath path: String) -> Data?  {
        return DefaultValueRegistry.defaultValue(for: (Data?).self)
    }
    
     override func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]?) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
}

