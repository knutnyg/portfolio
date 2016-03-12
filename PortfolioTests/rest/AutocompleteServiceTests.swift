
import Foundation
import XCTest

class AutocompleteServiceTests: XCTestCase {

    func testAutocomplete() {

        let tickers = ["NAS", "NOD", "MHG"]
        XCTAssertEqual(AutocompleteService.autoCompleteForInput(tickers, input: "N").count, 2)
        XCTAssertEqual(AutocompleteService.autoCompleteForInput(tickers, input: "Na").count, 1)
        XCTAssertEqual(AutocompleteService.autoCompleteForInput(tickers, input: "HG").count, 1)
    }


}
