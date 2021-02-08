// MARK: - Mocks generated from file: CombineWithREST/APIs/IdentityService.swift at 2021-02-08 23:44:31 +0000

//
//  IdentityService.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Cuckoo
@testable import CombineWithREST

import Combine
import Foundation


 class MockIdentityServiceProtocol: IdentityServiceProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = IdentityServiceProtocol
    
     typealias Stubbing = __StubbingProxy_IdentityServiceProtocol
     typealias Verification = __VerificationProxy_IdentityServiceProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: IdentityServiceProtocol?

     func enableDefaultImplementation(_ stub: IdentityServiceProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var fetchProfile: AnyPublisher<Result<User.Profile, API.IdentityService.FetchProfileError>, Never> {
        get {
            return cuckoo_manager.getter("fetchProfile",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.fetchProfile)
        }
        
    }
    

    

    

	 struct __StubbingProxy_IdentityServiceProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var fetchProfile: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockIdentityServiceProtocol, AnyPublisher<Result<User.Profile, API.IdentityService.FetchProfileError>, Never>> {
	        return .init(manager: cuckoo_manager, name: "fetchProfile")
	    }
	    
	    
	}

	 struct __VerificationProxy_IdentityServiceProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var fetchProfile: Cuckoo.VerifyReadOnlyProperty<AnyPublisher<Result<User.Profile, API.IdentityService.FetchProfileError>, Never>> {
	        return .init(manager: cuckoo_manager, name: "fetchProfile", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}
}

 class IdentityServiceProtocolStub: IdentityServiceProtocol {
    
    
     var fetchProfile: AnyPublisher<Result<User.Profile, API.IdentityService.FetchProfileError>, Never> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<User.Profile, API.IdentityService.FetchProfileError>, Never>).self)
        }
        
    }
    

    

    
}

