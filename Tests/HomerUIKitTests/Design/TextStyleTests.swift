import Testing
import UIKit
@testable import HomerUIKit

@Suite("TextStyle")
struct TextStyleTests {

    @Test("allCases lists the named tiers and excludes custom")
    func allCasesExcludesCustom() {
        #expect(TextStyle.allCases.count == 11)
        #expect(!TextStyle.allCases.contains { style in
            if case .custom = style { return true }
            return false
        })
    }

    @Test("every named tier maps to its UIFont.TextStyle", arguments: TextStyle.allCases)
    func namedTierMapping(style: TextStyle) {
        let uiStyle = style.uiTextStyle
        #expect(uiStyle != nil)
        if let uiStyle {
            #expect(style.font == UIFont.preferredFont(forTextStyle: uiStyle))
        }
    }

    @Test("specific tiers resolve to the expected UIFont.TextStyle")
    func specificMappings() {
        #expect(TextStyle.largeTitle.uiTextStyle == .largeTitle)
        #expect(TextStyle.title.uiTextStyle == .title1)
        #expect(TextStyle.headline.uiTextStyle == .headline)
        #expect(TextStyle.body.uiTextStyle == .body)
        #expect(TextStyle.caption.uiTextStyle == .caption1)
        #expect(TextStyle.caption2.uiTextStyle == .caption2)
    }

    @Test("custom has no UIFont.TextStyle and resolves to a fixed system font")
    func customResolvesFixedFont() {
        let style = TextStyle.custom(size: 11, weight: .semibold)
        #expect(style.uiTextStyle == nil)

        let font = style.font
        #expect(font.pointSize == 11)

        let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        let weight = traits?[.weight] as? CGFloat
        #expect(weight == UIFont.Weight.semibold.rawValue)
    }

    @Test("tokens are usable as dictionary keys")
    func hashableSemantics() {
        var fonts: [TextStyle: UIFont] = [:]
        fonts[.body] = TextStyle.body.font
        fonts[.body] = TextStyle.body.font
        fonts[.custom(size: 11, weight: .semibold)] = UIFont.systemFont(ofSize: 11)
        #expect(fonts.count == 2)
        #expect(TextStyle.custom(size: 11, weight: .semibold) == TextStyle.custom(size: 11, weight: .semibold))
        #expect(TextStyle.custom(size: 11, weight: .semibold) != TextStyle.custom(size: 11, weight: .bold))
    }
}

@Suite("UILabel TextStyle factory")
@MainActor
struct UILabelTextStyleFactoryTests {

    @Test("named tier produces a Dynamic Type label")
    func namedTierLabel() {
        let label = UILabel.dynamicType(.headline)
        #expect(label.font == UIFont.preferredFont(forTextStyle: .headline))
        #expect(label.adjustsFontForContentSizeCategory)
        #expect(label.numberOfLines == 0)
        #expect(label.textColor == .label)
    }

    @Test("custom tier produces a fixed-size label")
    func customTierLabel() {
        let label = UILabel.dynamicType(.custom(size: 11, weight: .semibold))
        #expect(label.font.pointSize == 11)
    }

    @Test("colour, line count, and alignment pass through")
    func configurationPassThrough() {
        let label = UILabel.dynamicType(
            .footnote,
            color: .secondaryLabel,
            numberOfLines: 2,
            textAlignment: .center
        )
        #expect(label.textColor == .secondaryLabel)
        #expect(label.numberOfLines == 2)
        #expect(label.textAlignment == .center)
    }
}
