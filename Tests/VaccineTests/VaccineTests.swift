import XCTest
@testable import Vaccine

final class VaccineTests: XCTestCase {
    func testCureForSomeService() {
        Vaccine.setCure(for: SomeServiceProtocol.self, with: SomeService(text: "Hello"))
        
        XCTAssertTrue(SomeViewModel().getText() == "Hello")
    }
    
    func testCureForSomeServiceEscaping() {
        Vaccine.setCure(for: SomeServiceProtocol.self) {
            let item = ["Hello", "World"].randomElement() ?? ""
            return SomeService(text: item)
        }
        
        XCTAssertFalse(SomeViewModel().getText().isEmpty)
    }
    
    func testUniqueCureForSomeService() {
        Vaccine.setCure(for: SomeServiceProtocol.self, isUnique: true, with: SomeService(text: "Hello"))
        
        let someViewModel = SomeViewModel()
        let anotherViewModel = AnotherViewModel()
        
        XCTAssertTrue(someViewModel.getText() == anotherViewModel.getText())
        
        someViewModel.setText("World")
        
        XCTAssertTrue(someViewModel.getText() == anotherViewModel.getText())
    }
    
    func testCureWithSomeServiceMock() {
        Vaccine.setCure(for: SomeServiceProtocol.self, with: SomeServiceMock())
        XCTAssertTrue(SomeViewModel().getText() == SomeServiceMock().getText())
    }
    
    static var allTests = [
        ("testCureForSomeService", testCureForSomeService),
        ("testCureForSomeServiceEscaping", testCureForSomeServiceEscaping),
        ("testUniqueCureForSomeService", testUniqueCureForSomeService),
        ("testCureWithSomeServiceMock", testCureWithSomeServiceMock),
    ]
}

class AnotherViewModel {
    @Inject(SomeServiceProtocol.self) var service
    
    func getText() -> String {
        service.getText()
    }
}

class SomeViewModel {
    @Inject(SomeServiceProtocol.self) var service
    
    func getText() -> String {
        service.getText()
    }
    
    func setText(_ text: String) {
        service.setText(text)
    }
}

protocol SomeServiceProtocol {
    func getText() -> String
    func setText(_ text: String)
}

class SomeService: SomeServiceProtocol {
    private var text: String
    
    init(text: String) {
        self.text = text
    }
    
    func getText() -> String {
        text
    }
    
    func setText(_ text: String) {
        self.text = text
    }
}

class SomeServiceMock: SomeServiceProtocol {
    func getText() -> String {
        "I am \(String(describing: self))"
    }
    
    func setText(_ text: String) {}
}


