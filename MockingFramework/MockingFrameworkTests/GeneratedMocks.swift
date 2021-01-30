// MARK: - Mocks generated from file: MockingFramework/SomeClass.swift at 2021-01-30 15:35:29 +0000

//
//  SomeClass.swift
//  MockingFramework
//
//  Created by thompsty on 1/5/21.
//

import Cuckoo
@testable import MockingFramework

import Foundation


 class MockSomeClass: SomeClass, Cuckoo.ClassMock {
    
     typealias MocksType = SomeClass
    
     typealias Stubbing = __StubbingProxy_SomeClass
     typealias Verification = __VerificationProxy_SomeClass

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: SomeClass?

     func enableDefaultImplementation(_ stub: SomeClass) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    

	 struct __StubbingProxy_SomeClass: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	}

	 struct __VerificationProxy_SomeClass: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	}
}

 class SomeClassStub: SomeClass {
    

    

    
}

