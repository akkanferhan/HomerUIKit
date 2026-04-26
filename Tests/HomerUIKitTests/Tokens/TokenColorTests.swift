import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("TokenColor token")
struct TokenColorTests {

    // MARK: System colors

    @Test("label resolves to UIColor.label")
    func labelResolvesToSystemLabel() {
        #expect(TokenColor.label.uiColor == UIColor.label)
    }

    @Test("clear resolves to a fully transparent color")
    func clearIsFullyTransparent() {
        var alpha: CGFloat = 1
        TokenColor.clear.uiColor.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        #expect(alpha == 0)
    }

    // MARK: black / white

    @Test("black(opacity:0.5) produces RGB=0 and alpha=0.5")
    func blackOpacityComponents() {
        var white: CGFloat = 1
        var alpha: CGFloat = 0
        TokenColor.black(opacity: 0.5).uiColor.getWhite(&white, alpha: &alpha)
        #expect(white == 0)
        #expect(alpha == 0.5)
    }

    // MARK: custom RGBA

    @Test("custom(1,0,0,1) resolves to red with full alpha")
    func customRGBARedFullAlpha() {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        TokenColor.custom(red: 1, green: 0, blue: 0, alpha: 1).uiColor
            .getRed(&r, green: &g, blue: &b, alpha: &a)
        #expect(r == 1)
        #expect(g == 0)
        #expect(b == 0)
        #expect(a == 1)
    }

    @Test("custom clamps components above 1 and below 0")
    func customRGBAComponentsClamped() {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        TokenColor.custom(red: 2, green: -1, blue: 0.5, alpha: 0.5).uiColor
            .getRed(&r, green: &g, blue: &b, alpha: &a)
        #expect(r == 1)
        #expect(g == 0)
        #expect(abs(b - 0.5) < 0.001)
        #expect(abs(a - 0.5) < 0.001)
    }

    // MARK: dynamic light/dark

    @Test("dynamic resolves to white in light trait collection")
    func dynamicResolvesToWhiteInLight() {
        let color = TokenColor.dynamic(light: .white(opacity: 1), dark: .black(opacity: 1)).uiColor
        let lightTrait = UITraitCollection(userInterfaceStyle: .light)
        let resolved = color.resolvedColor(with: lightTrait)
        var white: CGFloat = 0
        var alpha: CGFloat = 0
        resolved.getWhite(&white, alpha: &alpha)
        #expect(white == 1)
        #expect(alpha == 1)
    }

    @Test("dynamic resolves to black in dark trait collection")
    func dynamicResolvesToBlackInDark() {
        let color = TokenColor.dynamic(light: .white(opacity: 1), dark: .black(opacity: 1)).uiColor
        let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
        let resolved = color.resolvedColor(with: darkTrait)
        var white: CGFloat = 1
        var alpha: CGFloat = 0
        resolved.getWhite(&white, alpha: &alpha)
        #expect(white == 0)
        #expect(alpha == 1)
    }

    // MARK: Equatable / Hashable

    @Test("label equals label")
    func labelEqualsLabel() {
        #expect(TokenColor.label == TokenColor.label)
    }

    @Test("label does not equal secondaryLabel")
    func labelNotEqualSecondaryLabel() {
        #expect(TokenColor.label != TokenColor.secondaryLabel)
    }

    @Test("custom with same RGBA components are equal")
    func customSameComponentsAreEqual() {
        #expect(
            TokenColor.custom(red: 0, green: 0, blue: 0, alpha: 1) ==
            TokenColor.custom(red: 0, green: 0, blue: 0, alpha: 1)
        )
    }

    @Test("custom with different alpha are not equal")
    func customDifferentAlphaNotEqual() {
        #expect(
            TokenColor.custom(red: 0, green: 0, blue: 0, alpha: 1) !=
            TokenColor.custom(red: 0, green: 0, blue: 0, alpha: 0.5)
        )
    }
}
