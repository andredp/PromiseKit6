import XCTest
import PromiseKit6

class RaceTests: XCTestCase {
    func test1() {
        let ex = expectation(description: "")
        race6(after6(.milliseconds(10)).then{ Promise6.value(1) }, after6(seconds: 1).map{ 2 }).done { index in
            XCTAssertEqual(index, 1)
            ex.fulfill()
        }.silenceWarning()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test2() {
        let ex = expectation(description: "")
        race6(after6(seconds: 1).map{ 1 }, after6(.milliseconds(10)).map{ 2 }).done { index in
            XCTAssertEqual(index, 2)
            ex.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func test1Array() {
        let ex = expectation(description: "")
        let promises = [after6(.milliseconds(10)).map{ 1 }, after6(seconds: 1).map{ 2 }]
        race6(promises).done { index in
            XCTAssertEqual(index, 1)
            ex.fulfill()
        }.silenceWarning()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test2Array() {
        let ex = expectation(description: "")
        race6(after6(seconds: 1).map{ 1 }, after6(.milliseconds(10)).map{ 2 }).done { index in
            XCTAssertEqual(index, 2)
            ex.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testEmptyArray() {
        let ex = expectation(description: "")
        let empty = [Promise6<Int>]()
        race6(empty).catch {
            guard case PMKError6.badInput = $0 else { return XCTFail() }
            ex.fulfill()
        }
        wait(for: [ex], timeout: 10)
    }
}
