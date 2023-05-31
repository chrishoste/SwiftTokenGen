import XCTest
@testable import SwiftTokenGenCore

final class StringExtensionSpec: XCTestCase {
    let camelCaseSUT: [(String, String)] = [
        ("20 Seconds Back filled", "20SecondsBackFilled"),
        ("search", "search"),
        ("Seconds Forward", "secondsForward"),
        ("Checkmark", "checkmark"),
        ("Add person-1", "addPerson1"),
        ("Magazines", "magazines"),
        ("Speed 1", "speed1"),
        ("For-you", "forYou"),
        ("Repeat All filled", "repeatAllFilled"),
        ("A-Z filled", "aZFilled"),
        ("A-Z", "aZ"),
        ("profile-fallback", "profileFallback"),
        ("profile-00", "profile00"),
        ("Speed 1.0x", "speed10x")
    ]

    func testCamelCaseStringExtension() throws {
        camelCaseSUT.forEach {
            XCTAssertEqual($0.0.camelCase, $0.1)
        }
    }

    let removeWhitespaceSUT: [(String, String)] = [
        ("20 Seconds Back filled", "20SecondsBackfilled"),
        ("  search  ", "search"),
        ("Seconds Forward", "SecondsForward"),
        (" Checkmark  ", "Checkmark"),
        ("Add person-1", "Addperson-1"),
        (" Magazines ", "Magazines"),
        ("Speed 1", "Speed1"),
        ("   For-you ", "For-you"),
        ("Repeat All filled", "RepeatAllfilled"),
        ("A-Z filled", "A-Zfilled"),
        ("A-Z", "A-Z"),
        ("profile-fallback", "profile-fallback"),
        ("profile-00", "profile-00"),
        ("Speed 1.0x", "Speed1.0x")
    ]

    func testRemoveWhitespaceStringExtension() throws {
        removeWhitespaceSUT.forEach {
            XCTAssertEqual($0.0.removeWhitespace, $0.1)
        }
    }

    let firstCharacterUppercasedSUT: [(String, String)] = [
        ("20 Seconds Back filled", "20 Seconds Back filled"),
        ("search", "Search"),
        ("Seconds Forward", "Seconds Forward"),
        ("Checkmark", "Checkmark"),
        ("Add person-1", "Add person-1"),
        ("Magazines", "Magazines"),
        ("Speed 1", "Speed 1"),
        ("For-you", "For-you"),
        ("Repeat All filled", "Repeat All filled"),
        ("A-Z filled", "A-Z filled"),
        ("A-Z", "A-Z"),
        ("profile-fallback", "Profile-fallback"),
        ("profile-00", "Profile-00"),
        ("Speed 1.0x", "Speed 1.0x"),
        ("", "")
    ]

    func testFirstCharacterUppercasedStringExtension() throws {
        firstCharacterUppercasedSUT.forEach {
            XCTAssertEqual($0.0.firstCharacterUppercased, $0.1)
        }
    }

    let firstCharacterLowercasedSUT: [(String, String)] = [
        ("20 Seconds Back filled", "20 Seconds Back filled"),
        ("search", "search"),
        ("Seconds Forward", "seconds Forward"),
        ("Checkmark", "checkmark"),
        ("Add person-1", "add person-1"),
        ("Magazines", "magazines"),
        ("Speed 1", "speed 1"),
        ("For-you", "for-you"),
        ("Repeat All filled", "repeat All filled"),
        ("A-Z filled", "a-Z filled"),
        ("A-Z", "a-Z"),
        ("profile-fallback", "profile-fallback"),
        ("profile-00", "profile-00"),
        ("Speed 1.0x", "speed 1.0x"),
        ("", "")
    ]

    func testFirstCharacterLowercasedStringExtension() throws {
        firstCharacterLowercasedSUT.forEach {
            XCTAssertEqual($0.0.firstCharacterLowercased, $0.1)
        }
    }
}
