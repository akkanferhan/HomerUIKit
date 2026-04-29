import Testing
import UIKit
@testable import HomerUIKit

@Suite("UIActivityIndicatorView make factory")
@MainActor
struct UIActivityIndicatorViewConvenienceTests {

    @Test("make defaults to medium style")
    func makeDefaultsToMediumStyle() {
        let indicator = UIActivityIndicatorView.make()
        #expect(indicator.style == .medium)
    }

    @Test("make honours an overridden style")
    func makeHonoursOverriddenStyle() {
        let indicator = UIActivityIndicatorView.make(style: .large)
        #expect(indicator.style == .large)
    }

    @Test("make defaults color to systemGray")
    func makeDefaultsColor() {
        let indicator = UIActivityIndicatorView.make()
        #expect(indicator.color == UIColor.systemGray)
    }

    @Test("make honours an overridden color")
    func makeHonoursOverriddenColor() {
        let indicator = UIActivityIndicatorView.make(color: .systemTeal)
        #expect(indicator.color == UIColor.systemTeal)
    }

    @Test("make defaults hidesWhenStopped to true")
    func makeDefaultsHidesWhenStopped() {
        let indicator = UIActivityIndicatorView.make()
        #expect(indicator.hidesWhenStopped)
    }

    @Test("make can disable hidesWhenStopped for footer-style usage")
    func makeCanDisableHidesWhenStopped() {
        let indicator = UIActivityIndicatorView.make(hidesWhenStopped: false)
        #expect(!indicator.hidesWhenStopped)
    }
}
