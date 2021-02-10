// MARK: - Mocks generated from file: MockingFramework/SomeClass.swift at 2021-02-10 17:12:20 +0000

//
//  SomeClass.swift
//  MockingFramework
//
//  Created by thompsty on 1/5/21.
//

import Cuckoo
@testable import MockingFramework

import Foundation


 class MockSomeSuperClass: SomeSuperClass, Cuckoo.ClassMock {
    
     typealias MocksType = SomeSuperClass
    
     typealias Stubbing = __StubbingProxy_SomeSuperClass
     typealias Verification = __VerificationProxy_SomeSuperClass

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: SomeSuperClass?

     func enableDefaultImplementation(_ stub: SomeSuperClass) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     override var readOnlyProperty: String {
        get {
            return cuckoo_manager.getter("readOnlyProperty",
                superclassCall:
                    
                    super.readOnlyProperty
                    ,
                defaultCall: __defaultImplStub!.readOnlyProperty)
        }
        
    }
    
    
    
     override var readWriteProperty: String {
        get {
            return cuckoo_manager.getter("readWriteProperty",
                superclassCall:
                    
                    super.readWriteProperty
                    ,
                defaultCall: __defaultImplStub!.readWriteProperty)
        }
        
        set {
            cuckoo_manager.setter("readWriteProperty",
                value: newValue,
                superclassCall:
                    
                    super.readWriteProperty = newValue
                    ,
                defaultCall: __defaultImplStub!.readWriteProperty = newValue)
        }
        
    }
    
    
    
     override var lazy: String {
        get {
            return cuckoo_manager.getter("lazy",
                superclassCall:
                    
                    super.lazy
                    ,
                defaultCall: __defaultImplStub!.lazy)
        }
        
        set {
            cuckoo_manager.setter("lazy",
                value: newValue,
                superclassCall:
                    
                    super.lazy = newValue
                    ,
                defaultCall: __defaultImplStub!.lazy = newValue)
        }
        
    }
    

    

    
    
    
     override func voidMethod()  {
        
    return cuckoo_manager.call("voidMethod()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.voidMethod()
                ,
            defaultCall: __defaultImplStub!.voidMethod())
        
    }
    
    
    
     override func genericVoid<T>(param: T)  {
        
    return cuckoo_manager.call("genericVoid(param: T)",
            parameters: (param),
            escapingParameters: (param),
            superclassCall:
                
                super.genericVoid(param: param)
                ,
            defaultCall: __defaultImplStub!.genericVoid(param: param))
        
    }
    
    
    
     override func genericReturn<T>(param: T) -> T {
        
    return cuckoo_manager.call("genericReturn(param: T) -> T",
            parameters: (param),
            escapingParameters: (param),
            superclassCall:
                
                super.genericReturn(param: param)
                ,
            defaultCall: __defaultImplStub!.genericReturn(param: param))
        
    }
    

	 struct __StubbingProxy_SomeSuperClass: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var readOnlyProperty: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSomeSuperClass, String> {
	        return .init(manager: cuckoo_manager, name: "readOnlyProperty")
	    }
	    
	    
	    var readWriteProperty: Cuckoo.ClassToBeStubbedProperty<MockSomeSuperClass, String> {
	        return .init(manager: cuckoo_manager, name: "readWriteProperty")
	    }
	    
	    
	    var lazy: Cuckoo.ClassToBeStubbedProperty<MockSomeSuperClass, String> {
	        return .init(manager: cuckoo_manager, name: "lazy")
	    }
	    
	    
	    func voidMethod() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeSuperClass.self, method: "voidMethod()", parameterMatchers: matchers))
	    }
	    
	    func genericVoid<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.ClassStubNoReturnFunction<(T)> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeSuperClass.self, method: "genericVoid(param: T)", parameterMatchers: matchers))
	    }
	    
	    func genericReturn<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.ClassStubFunction<(T), T> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeSuperClass.self, method: "genericReturn(param: T) -> T", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_SomeSuperClass: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var readOnlyProperty: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "readOnlyProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var readWriteProperty: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "readWriteProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var lazy: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "lazy", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func voidMethod() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("voidMethod()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func genericVoid<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return cuckoo_manager.verify("genericVoid(param: T)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func genericReturn<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.__DoNotUse<(T), T> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return cuckoo_manager.verify("genericReturn(param: T) -> T", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class SomeSuperClassStub: SomeSuperClass {
    
    
     override var readOnlyProperty: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
     override var readWriteProperty: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    
     override var lazy: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    

    

    
     override func voidMethod()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func genericVoid<T>(param: T)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func genericReturn<T>(param: T) -> T  {
        return DefaultValueRegistry.defaultValue(for: (T).self)
    }
    
}



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
    

    
    
    
     override var readOnlyProperty: String {
        get {
            return cuckoo_manager.getter("readOnlyProperty",
                superclassCall:
                    
                    super.readOnlyProperty
                    ,
                defaultCall: __defaultImplStub!.readOnlyProperty)
        }
        
    }
    
    
    
     override var readWriteProperty: String {
        get {
            return cuckoo_manager.getter("readWriteProperty",
                superclassCall:
                    
                    super.readWriteProperty
                    ,
                defaultCall: __defaultImplStub!.readWriteProperty)
        }
        
        set {
            cuckoo_manager.setter("readWriteProperty",
                value: newValue,
                superclassCall:
                    
                    super.readWriteProperty = newValue
                    ,
                defaultCall: __defaultImplStub!.readWriteProperty = newValue)
        }
        
    }
    
    
    
     override var lazy: String {
        get {
            return cuckoo_manager.getter("lazy",
                superclassCall:
                    
                    super.lazy
                    ,
                defaultCall: __defaultImplStub!.lazy)
        }
        
        set {
            cuckoo_manager.setter("lazy",
                value: newValue,
                superclassCall:
                    
                    super.lazy = newValue
                    ,
                defaultCall: __defaultImplStub!.lazy = newValue)
        }
        
    }
    

    

    
    
    
     override func returnsBoolean() -> Bool {
        
    return cuckoo_manager.call("returnsBoolean() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.returnsBoolean()
                ,
            defaultCall: __defaultImplStub!.returnsBoolean())
        
    }
    
    
    
     override func genericVoid<T>(param: T)  {
        
    return cuckoo_manager.call("genericVoid(param: T)",
            parameters: (param),
            escapingParameters: (param),
            superclassCall:
                
                super.genericVoid(param: param)
                ,
            defaultCall: __defaultImplStub!.genericVoid(param: param))
        
    }
    
    
    
     override func voidMethod()  {
        
    return cuckoo_manager.call("voidMethod()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.voidMethod()
                ,
            defaultCall: __defaultImplStub!.voidMethod())
        
    }
    
    
    
     override func genericReturn<T>(param: T) -> T {
        
    return cuckoo_manager.call("genericReturn(param: T) -> T",
            parameters: (param),
            escapingParameters: (param),
            superclassCall:
                
                super.genericReturn(param: param)
                ,
            defaultCall: __defaultImplStub!.genericReturn(param: param))
        
    }
    

	 struct __StubbingProxy_SomeClass: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var readOnlyProperty: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSomeClass, String> {
	        return .init(manager: cuckoo_manager, name: "readOnlyProperty")
	    }
	    
	    
	    var readWriteProperty: Cuckoo.ClassToBeStubbedProperty<MockSomeClass, String> {
	        return .init(manager: cuckoo_manager, name: "readWriteProperty")
	    }
	    
	    
	    var lazy: Cuckoo.ClassToBeStubbedProperty<MockSomeClass, String> {
	        return .init(manager: cuckoo_manager, name: "lazy")
	    }
	    
	    
	    func returnsBoolean() -> Cuckoo.ClassStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeClass.self, method: "returnsBoolean() -> Bool", parameterMatchers: matchers))
	    }
	    
	    func genericVoid<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.ClassStubNoReturnFunction<(T)> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeClass.self, method: "genericVoid(param: T)", parameterMatchers: matchers))
	    }
	    
	    func voidMethod() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeClass.self, method: "voidMethod()", parameterMatchers: matchers))
	    }
	    
	    func genericReturn<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.ClassStubFunction<(T), T> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeClass.self, method: "genericReturn(param: T) -> T", parameterMatchers: matchers))
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
	
	    
	    
	    var readOnlyProperty: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "readOnlyProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var readWriteProperty: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "readWriteProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var lazy: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "lazy", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func returnsBoolean() -> Cuckoo.__DoNotUse<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("returnsBoolean() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func genericVoid<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return cuckoo_manager.verify("genericVoid(param: T)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func voidMethod() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("voidMethod()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func genericReturn<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.__DoNotUse<(T), T> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return cuckoo_manager.verify("genericReturn(param: T) -> T", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class SomeClassStub: SomeClass {
    
    
     override var readOnlyProperty: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
     override var readWriteProperty: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    
     override var lazy: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    

    

    
     override func returnsBoolean() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
     override func genericVoid<T>(param: T)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func voidMethod()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func genericReturn<T>(param: T) -> T  {
        return DefaultValueRegistry.defaultValue(for: (T).self)
    }
    
}


// MARK: - Mocks generated from file: MockingFramework/SomeStruct.swift at 2021-02-10 17:12:20 +0000

//
//  SomeStruct.swift
//  MockingFramework
//
//  Created by Heather Meadow on 2/10/21.
//

import Cuckoo
@testable import MockingFramework

import Foundation


 class MockSomeProtocol: SomeProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = SomeProtocol
    
     typealias Stubbing = __StubbingProxy_SomeProtocol
     typealias Verification = __VerificationProxy_SomeProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SomeProtocol?

     func enableDefaultImplementation(_ stub: SomeProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var readOnlyProperty: String {
        get {
            return cuckoo_manager.getter("readOnlyProperty",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.readOnlyProperty)
        }
        
    }
    
    
    
     var readWriteProperty: String {
        get {
            return cuckoo_manager.getter("readWriteProperty",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.readWriteProperty)
        }
        
        set {
            cuckoo_manager.setter("readWriteProperty",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.readWriteProperty = newValue)
        }
        
    }
    
    
    
     var lazy: String {
        get {
            return cuckoo_manager.getter("lazy",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.lazy)
        }
        
    }
    

    

    
    
    
     func voidMethod()  {
        
    return cuckoo_manager.call("voidMethod()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.voidMethod())
        
    }
    
    
    
     func returnsBoolean() -> Bool {
        
    return cuckoo_manager.call("returnsBoolean() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.returnsBoolean())
        
    }
    
    
    
     func genericVoid<T>(param: T)  {
        
    return cuckoo_manager.call("genericVoid(param: T)",
            parameters: (param),
            escapingParameters: (param),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.genericVoid(param: param))
        
    }
    
    
    
     func genericReturn<T>(param: T) -> T {
        
    return cuckoo_manager.call("genericReturn(param: T) -> T",
            parameters: (param),
            escapingParameters: (param),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.genericReturn(param: param))
        
    }
    

	 struct __StubbingProxy_SomeProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var readOnlyProperty: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSomeProtocol, String> {
	        return .init(manager: cuckoo_manager, name: "readOnlyProperty")
	    }
	    
	    
	    var readWriteProperty: Cuckoo.ProtocolToBeStubbedProperty<MockSomeProtocol, String> {
	        return .init(manager: cuckoo_manager, name: "readWriteProperty")
	    }
	    
	    
	    var lazy: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSomeProtocol, String> {
	        return .init(manager: cuckoo_manager, name: "lazy")
	    }
	    
	    
	    func voidMethod() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeProtocol.self, method: "voidMethod()", parameterMatchers: matchers))
	    }
	    
	    func returnsBoolean() -> Cuckoo.ProtocolStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeProtocol.self, method: "returnsBoolean() -> Bool", parameterMatchers: matchers))
	    }
	    
	    func genericVoid<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(T)> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeProtocol.self, method: "genericVoid(param: T)", parameterMatchers: matchers))
	    }
	    
	    func genericReturn<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.ProtocolStubFunction<(T), T> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSomeProtocol.self, method: "genericReturn(param: T) -> T", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_SomeProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var readOnlyProperty: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "readOnlyProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var readWriteProperty: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "readWriteProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var lazy: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "lazy", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func voidMethod() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("voidMethod()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func returnsBoolean() -> Cuckoo.__DoNotUse<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("returnsBoolean() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func genericVoid<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return cuckoo_manager.verify("genericVoid(param: T)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func genericReturn<M1: Cuckoo.Matchable, T>(param: M1) -> Cuckoo.__DoNotUse<(T), T> where M1.MatchedType == T {
	        let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: param) { $0 }]
	        return cuckoo_manager.verify("genericReturn(param: T) -> T", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class SomeProtocolStub: SomeProtocol {
    
    
     var readOnlyProperty: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
     var readWriteProperty: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    
     var lazy: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    

    

    
     func voidMethod()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func returnsBoolean() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
     func genericVoid<T>(param: T)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func genericReturn<T>(param: T) -> T  {
        return DefaultValueRegistry.defaultValue(for: (T).self)
    }
    
}

