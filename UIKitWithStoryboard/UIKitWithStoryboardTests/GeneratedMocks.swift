// MARK: - Mocks generated from file: UIKitWithStoryboard/Protocols/FileWriteable.swift at 2021-02-11 22:01:27 +0000

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


// MARK: - Mocks generated from file: UIKitWithStoryboard/Services/NotesService.swift at 2021-02-11 22:01:27 +0000

//
//  NotesService.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/10/21.
//

import Cuckoo
@testable import UIKitWithStoryboard

import Foundation
import Swinject


 class MockNotesService: NotesService, Cuckoo.ClassMock {
    
     typealias MocksType = NotesService
    
     typealias Stubbing = __StubbingProxy_NotesService
     typealias Verification = __VerificationProxy_NotesService

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: NotesService?

     func enableDefaultImplementation(_ stub: NotesService) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     override var directoryEnumerator: FileManager.DirectoryEnumerator? {
        get {
            return cuckoo_manager.getter("directoryEnumerator",
                superclassCall:
                    
                    super.directoryEnumerator
                    ,
                defaultCall: __defaultImplStub!.directoryEnumerator)
        }
        
        set {
            cuckoo_manager.setter("directoryEnumerator",
                value: newValue,
                superclassCall:
                    
                    super.directoryEnumerator = newValue
                    ,
                defaultCall: __defaultImplStub!.directoryEnumerator = newValue)
        }
        
    }
    

    

    
    
    
     override func writeNote(at url: URL, contents: FileWriteable) throws {
        
    return try cuckoo_manager.callThrows("writeNote(at: URL, contents: FileWriteable) throws",
            parameters: (url, contents),
            escapingParameters: (url, contents),
            superclassCall:
                
                super.writeNote(at: url, contents: contents)
                ,
            defaultCall: __defaultImplStub!.writeNote(at: url, contents: contents))
        
    }
    
    
    
     override func save<N: NoteWriteable>(note: N) throws {
        
    return try cuckoo_manager.callThrows("save(note: N) throws",
            parameters: (note),
            escapingParameters: (note),
            superclassCall:
                
                super.save(note: note)
                ,
            defaultCall: __defaultImplStub!.save(note: note))
        
    }
    
    
    
     override func getNotes() -> Result<[Note], Error> {
        
    return cuckoo_manager.call("getNotes() -> Result<[Note], Error>",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getNotes()
                ,
            defaultCall: __defaultImplStub!.getNotes())
        
    }
    

	 struct __StubbingProxy_NotesService: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var directoryEnumerator: Cuckoo.ClassToBeStubbedOptionalProperty<MockNotesService, FileManager.DirectoryEnumerator> {
	        return .init(manager: cuckoo_manager, name: "directoryEnumerator")
	    }
	    
	    
	    func writeNote<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(at url: M1, contents: M2) -> Cuckoo.ClassStubNoReturnThrowingFunction<(URL, FileWriteable)> where M1.MatchedType == URL, M2.MatchedType == FileWriteable {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, FileWriteable)>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: contents) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockNotesService.self, method: "writeNote(at: URL, contents: FileWriteable) throws", parameterMatchers: matchers))
	    }
	    
	    func save<M1: Cuckoo.Matchable, N: NoteWriteable>(note: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(N)> where M1.MatchedType == N {
	        let matchers: [Cuckoo.ParameterMatcher<(N)>] = [wrap(matchable: note) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockNotesService.self, method: "save(note: N) throws", parameterMatchers: matchers))
	    }
	    
	    func getNotes() -> Cuckoo.ClassStubFunction<(), Result<[Note], Error>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockNotesService.self, method: "getNotes() -> Result<[Note], Error>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_NotesService: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var directoryEnumerator: Cuckoo.VerifyOptionalProperty<FileManager.DirectoryEnumerator> {
	        return .init(manager: cuckoo_manager, name: "directoryEnumerator", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func writeNote<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(at url: M1, contents: M2) -> Cuckoo.__DoNotUse<(URL, FileWriteable), Void> where M1.MatchedType == URL, M2.MatchedType == FileWriteable {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, FileWriteable)>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: contents) { $0.1 }]
	        return cuckoo_manager.verify("writeNote(at: URL, contents: FileWriteable) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func save<M1: Cuckoo.Matchable, N: NoteWriteable>(note: M1) -> Cuckoo.__DoNotUse<(N), Void> where M1.MatchedType == N {
	        let matchers: [Cuckoo.ParameterMatcher<(N)>] = [wrap(matchable: note) { $0 }]
	        return cuckoo_manager.verify("save(note: N) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getNotes() -> Cuckoo.__DoNotUse<(), Result<[Note], Error>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getNotes() -> Result<[Note], Error>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class NotesServiceStub: NotesService {
    
    
     override var directoryEnumerator: FileManager.DirectoryEnumerator? {
        get {
            return DefaultValueRegistry.defaultValue(for: (FileManager.DirectoryEnumerator?).self)
        }
        
        set { }
        
    }
    

    

    
     override func writeNote(at url: URL, contents: FileWriteable) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func save<N: NoteWriteable>(note: N) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func getNotes() -> Result<[Note], Error>  {
        return DefaultValueRegistry.defaultValue(for: (Result<[Note], Error>).self)
    }
    
}


// MARK: - Mocks generated from file: UIKitWithStoryboardTests/Mocks/MockDirectoryEnumerator.swift at 2021-02-11 22:01:27 +0000

//
//  MockDirectoryEnumerator.swift
//  UIKitWithStoryboardTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Cuckoo
@testable import UIKitWithStoryboard

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
    

    

    

    
    
    
     override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        
    return cuckoo_manager.call("urls(for: FileManager.SearchPathDirectory, in: FileManager.SearchPathDomainMask) -> [URL]",
            parameters: (directory, domainMask),
            escapingParameters: (directory, domainMask),
            superclassCall:
                
                super.urls(for: directory, in: domainMask)
                ,
            defaultCall: __defaultImplStub!.urls(for: directory, in: domainMask))
        
    }
    
    
    
     override func url(for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask, appropriateFor url: URL?, create shouldCreate: Bool) throws -> URL {
        
    return try cuckoo_manager.callThrows("url(for: FileManager.SearchPathDirectory, in: FileManager.SearchPathDomainMask, appropriateFor: URL?, create: Bool) throws -> URL",
            parameters: (directory, domain, url, shouldCreate),
            escapingParameters: (directory, domain, url, shouldCreate),
            superclassCall:
                
                super.url(for: directory, in: domain, appropriateFor: url, create: shouldCreate)
                ,
            defaultCall: __defaultImplStub!.url(for: directory, in: domain, appropriateFor: url, create: shouldCreate))
        
    }
    

	 struct __StubbingProxy_FileManager: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func urls<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for directory: M1, in domainMask: M2) -> Cuckoo.ClassStubFunction<(FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask), [URL]> where M1.MatchedType == FileManager.SearchPathDirectory, M2.MatchedType == FileManager.SearchPathDomainMask {
	        let matchers: [Cuckoo.ParameterMatcher<(FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask)>] = [wrap(matchable: directory) { $0.0 }, wrap(matchable: domainMask) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockFileManager.self, method: "urls(for: FileManager.SearchPathDirectory, in: FileManager.SearchPathDomainMask) -> [URL]", parameterMatchers: matchers))
	    }
	    
	    func url<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.Matchable>(for directory: M1, in domain: M2, appropriateFor url: M3, create shouldCreate: M4) -> Cuckoo.ClassStubThrowingFunction<(FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask, URL?, Bool), URL> where M1.MatchedType == FileManager.SearchPathDirectory, M2.MatchedType == FileManager.SearchPathDomainMask, M3.OptionalMatchedType == URL, M4.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask, URL?, Bool)>] = [wrap(matchable: directory) { $0.0 }, wrap(matchable: domain) { $0.1 }, wrap(matchable: url) { $0.2 }, wrap(matchable: shouldCreate) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockFileManager.self, method: "url(for: FileManager.SearchPathDirectory, in: FileManager.SearchPathDomainMask, appropriateFor: URL?, create: Bool) throws -> URL", parameterMatchers: matchers))
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
	    func urls<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for directory: M1, in domainMask: M2) -> Cuckoo.__DoNotUse<(FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask), [URL]> where M1.MatchedType == FileManager.SearchPathDirectory, M2.MatchedType == FileManager.SearchPathDomainMask {
	        let matchers: [Cuckoo.ParameterMatcher<(FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask)>] = [wrap(matchable: directory) { $0.0 }, wrap(matchable: domainMask) { $0.1 }]
	        return cuckoo_manager.verify("urls(for: FileManager.SearchPathDirectory, in: FileManager.SearchPathDomainMask) -> [URL]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func url<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.Matchable>(for directory: M1, in domain: M2, appropriateFor url: M3, create shouldCreate: M4) -> Cuckoo.__DoNotUse<(FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask, URL?, Bool), URL> where M1.MatchedType == FileManager.SearchPathDirectory, M2.MatchedType == FileManager.SearchPathDomainMask, M3.OptionalMatchedType == URL, M4.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask, URL?, Bool)>] = [wrap(matchable: directory) { $0.0 }, wrap(matchable: domain) { $0.1 }, wrap(matchable: url) { $0.2 }, wrap(matchable: shouldCreate) { $0.3 }]
	        return cuckoo_manager.verify("url(for: FileManager.SearchPathDirectory, in: FileManager.SearchPathDomainMask, appropriateFor: URL?, create: Bool) throws -> URL", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class FileManagerStub: FileManager {
    

    

    
     override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]  {
        return DefaultValueRegistry.defaultValue(for: ([URL]).self)
    }
    
     override func url(for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask, appropriateFor url: URL?, create shouldCreate: Bool) throws -> URL  {
        return DefaultValueRegistry.defaultValue(for: (URL).self)
    }
    
}



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

