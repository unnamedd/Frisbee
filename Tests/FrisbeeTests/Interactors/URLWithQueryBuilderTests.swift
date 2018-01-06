import XCTest
@testable import Frisbee

class URLWithQueryBuilderTests: XCTestCase {

    struct MovieQuery: Encodable {
        let page: Int
        let keyAccess: String
        let optionalInt: Int?

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case page, keyAccess = "key_access", optionalInt = "optional_int"
        }
    }

    func testBuildURLWhenHasCorrectQueryWithNilValueThenGenerateURLWithQueryStrings() {
        let query = MovieQuery(page: 1, keyAccess: "a1d13so979", optionalInt: nil)
        let url = "http://www.com.br"

        let builtUrl = try? URLWithQueryBuilder.build(withUrl: url, query: query)

        XCTAssertTrue(builtUrl?.absoluteString.starts(with: url) ?? false)
        XCTAssertEqual("\(query.page)", getQueryValue(builtUrl?.absoluteString, "page"))
        XCTAssertEqual("\(query.keyAccess)", getQueryValue(builtUrl?.absoluteString, "key_access"))
        XCTAssertNil(getQueryValue(builtUrl?.absoluteString, "optional_int"))
    }

    func testBuildURLWhenHasCorrectQueryWithoutNilValueThenGenerateURLWithQueryStrings() {
        let query = MovieQuery(page: 1, keyAccess: "a1d13so979", optionalInt: 10)
        let url = "http://www.com.br"

        let builtUrl = try? URLWithQueryBuilder.build(withUrl: url, query: query)

        XCTAssertTrue(builtUrl?.absoluteString.starts(with: url) ?? false)
        XCTAssertEqual("\(query.page)", getQueryValue(builtUrl?.absoluteString, "page"))
        XCTAssertEqual("\(query.keyAccess)", getQueryValue(builtUrl?.absoluteString, "key_access"))
        XCTAssertEqual("\(query.optionalInt ?? 0)", getQueryValue(builtUrl?.absoluteString, "optional_int"))
    }

    func testBuildURLWhenHasInvalidUrlThenThrowInvalidURLError() {
        let query = MovieQuery(page: 1, keyAccess: "a1d13so979", optionalInt: 10)
        let url = "http://www.çøµ.∫®"

        XCTAssertThrowsError(try URLWithQueryBuilder.build(withUrl: url, query: query))
    }

    private func getQueryValue(_ urlString: String?, _ param: String) -> String? {
        guard let urlString = urlString, let url = URLComponents(string: urlString) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }

    static var allTests = [
        ("testBuildURLWhenHasCorrectQueryWithNilValueThenGenerateURLWithQueryStrings",
         testBuildURLWhenHasCorrectQueryWithNilValueThenGenerateURLWithQueryStrings),
        ("testBuildURLWhenHasCorrectQueryWithoutNilValueThenGenerateURLWithQueryStrings",
         testBuildURLWhenHasCorrectQueryWithoutNilValueThenGenerateURLWithQueryStrings),
        ("testBuildURLWhenHasInvalidUrlThenThrowInvalidURLError",
         testBuildURLWhenHasInvalidUrlThenThrowInvalidURLError)
    ]

}