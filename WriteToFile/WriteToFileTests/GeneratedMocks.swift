// MARK: - Mocks generated from file: WriteToFile/Protocols/FileWriteable.swift at 2021-02-03 15:33:29 +0000

//
//  FileWriteable.swift
//  WriteToFile
//
//  Created by thompsty on 2/3/21.
//

import Cuckoo
@testable import WriteToFile

import Foundation


 class MockFileWriteable: FileWriteable, Cuckoo.ProtocolMock {
    
     typealias MocksType = FileWriteable
    
     typealias Stubbing = __StubbingProxy_FileWriteable
     typealias Verification = __VerificationProxy_FileWriteable

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FileWriteable?

     func enableDefaultImplementation(_ stub: FileWriteable) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func write(to: URL, atomically: Bool, encoding: String.Encoding) throws {
        
    return try cuckoo_manager.callThrows("write(to: URL, atomically: Bool, encoding: String.Encoding) throws",
            parameters: (to, atomically, encoding),
            escapingParameters: (to, atomically, encoding),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.write(to: to, atomically: atomically, encoding: encoding))
        
    }
    

	 struct __StubbingProxy_FileWriteable: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func write<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(to: M1, atomically: M2, encoding: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(URL, Bool, String.Encoding)> where M1.MatchedType == URL, M2.MatchedType == Bool, M3.MatchedType == String.Encoding {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, Bool, String.Encoding)>] = [wrap(matchable: to) { $0.0 }, wrap(matchable: atomically) { $0.1 }, wrap(matchable: encoding) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockFileWriteable.self, method: "write(to: URL, atomically: Bool, encoding: String.Encoding) throws", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_FileWriteable: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func write<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(to: M1, atomically: M2, encoding: M3) -> Cuckoo.__DoNotUse<(URL, Bool, String.Encoding), Void> where M1.MatchedType == URL, M2.MatchedType == Bool, M3.MatchedType == String.Encoding {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, Bool, String.Encoding)>] = [wrap(matchable: to) { $0.0 }, wrap(matchable: atomically) { $0.1 }, wrap(matchable: encoding) { $0.2 }]
	        return cuckoo_manager.verify("write(to: URL, atomically: Bool, encoding: String.Encoding) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class FileWriteableStub: FileWriteable {
    

    

    
     func write(to: URL, atomically: Bool, encoding: String.Encoding) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: WriteToFileTests/MockFileManager.swift at 2021-02-03 15:33:29 +0000

//
//  MockFileManager.swift
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

