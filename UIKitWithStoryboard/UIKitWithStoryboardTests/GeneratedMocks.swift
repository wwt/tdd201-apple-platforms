// MARK: - Mocks generated from file: UIKitWithStoryboard/Protocols/FileWriteable.swift at 2021-02-11 00:21:37 +0000

//
//  FileWriteable.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/10/21.
//

import Cuckoo
@testable import UIKitWithStoryboard

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


// MARK: - Mocks generated from file: UIKitWithStoryboardTests/Mocks/MockFileManager.swift at 2021-02-11 00:21:37 +0000

//
//  MockFileManager.swift
//  UIKitWithStoryboardTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Cuckoo
@testable import UIKitWithStoryboard

import Foundation


 class MockDirectoryEnumerator: DirectoryEnumerator, Cuckoo.ClassMock {
    
     typealias MocksType = DirectoryEnumerator
    
     typealias Stubbing = __StubbingProxy_DirectoryEnumerator
     typealias Verification = __VerificationProxy_DirectoryEnumerator

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: DirectoryEnumerator?

     func enableDefaultImplementation(_ stub: DirectoryEnumerator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func nextObject() -> Any? {
        
    return cuckoo_manager.call("nextObject() -> Any?",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.nextObject()
                ,
            defaultCall: __defaultImplStub!.nextObject())
        
    }
    

	 struct __StubbingProxy_DirectoryEnumerator: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func nextObject() -> Cuckoo.ClassStubFunction<(), Any?> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDirectoryEnumerator.self, method: "nextObject() -> Any?", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_DirectoryEnumerator: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func nextObject() -> Cuckoo.__DoNotUse<(), Any?> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("nextObject() -> Any?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class DirectoryEnumeratorStub: DirectoryEnumerator {
    

    

    
     override func nextObject() -> Any?  {
        return DefaultValueRegistry.defaultValue(for: (Any?).self)
    }
    
}

