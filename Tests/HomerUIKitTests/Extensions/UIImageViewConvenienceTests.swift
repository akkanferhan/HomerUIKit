import Testing
import UIKit
@testable import HomerUIKit

@Suite("UIImageView aspectFill factory")
@MainActor
struct UIImageViewConvenienceTests {

    @Test("aspectFill sets scaleAspectFill content mode")
    func aspectFillSetsContentMode() {
        let view = UIImageView.aspectFill()
        #expect(view.contentMode == .scaleAspectFill)
    }

    @Test("aspectFill enables clipsToBounds")
    func aspectFillEnablesClipping() {
        let view = UIImageView.aspectFill()
        #expect(view.clipsToBounds)
    }

    @Test("aspectFill defaults backgroundColor to secondarySystemBackground")
    func aspectFillDefaultsBackgroundColor() {
        let view = UIImageView.aspectFill()
        #expect(view.backgroundColor == UIColor.secondarySystemBackground)
    }

    @Test("aspectFill honours an overridden backgroundColor")
    func aspectFillHonoursOverriddenBackground() {
        let view = UIImageView.aspectFill(backgroundColor: .systemTeal)
        #expect(view.backgroundColor == UIColor.systemTeal)
    }

    @Test("aspectFill skips cornerRadius when zero")
    func aspectFillSkipsCornerRadiusWhenZero() {
        let view = UIImageView.aspectFill()
        #expect(view.layer.cornerRadius == 0)
    }

    @Test("aspectFill skips cornerRadius when negative")
    func aspectFillSkipsCornerRadiusWhenNegative() {
        let view = UIImageView.aspectFill(cornerRadius: -8)
        #expect(view.layer.cornerRadius == 0)
    }

    @Test("aspectFill applies a positive cornerRadius")
    func aspectFillAppliesCornerRadius() {
        let view = UIImageView.aspectFill(cornerRadius: 12)
        #expect(view.layer.cornerRadius == 12)
    }
}
