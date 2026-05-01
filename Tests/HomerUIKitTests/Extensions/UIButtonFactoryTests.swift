import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIButton+Factory")
struct UIButtonFactoryTests {

    // MARK: filled

    @Test("filled assigns title, image, and base background")
    func filledAssignsConfiguration() {
        let image = UIImage(systemName: "checkmark")
        let button = UIButton.filled(title: "Save", image: image, tintColor: .systemBlue)
        let config = button.configuration
        #expect(config?.title == "Save")
        #expect(config?.image === image)
        #expect(config?.baseBackgroundColor == .systemBlue)
        #expect(button.tintColor == .systemBlue)
    }

    @Test("filled supports an icon-only button when title is nil")
    func filledIconOnly() {
        let image = UIImage(systemName: "trash")
        let button = UIButton.filled(image: image)
        #expect(button.configuration?.title == nil)
        #expect(button.configuration?.image === image)
    }

    // MARK: tinted

    @Test("tinted assigns title and base foreground")
    func tintedAssignsConfiguration() {
        let button = UIButton.tinted(title: "Cancel", tintColor: .systemRed)
        #expect(button.configuration?.title == "Cancel")
        #expect(button.configuration?.baseForegroundColor == .systemRed)
        #expect(button.tintColor == .systemRed)
    }

    // MARK: plain

    @Test("plain assigns title and base foreground")
    func plainAssignsConfiguration() {
        let button = UIButton.plain(title: "Skip", tintColor: .systemGreen)
        #expect(button.configuration?.title == "Skip")
        #expect(button.configuration?.baseForegroundColor == .systemGreen)
    }

    // MARK: bordered

    @Test("bordered assigns title and image")
    func borderedAssignsConfiguration() {
        let image = UIImage(systemName: "info.circle")
        let button = UIButton.bordered(title: "Learn more", image: image)
        #expect(button.configuration?.title == "Learn more")
        #expect(button.configuration?.image === image)
    }

    @Test("each factory produces a button with a non-nil configuration")
    func factoriesProduceConfiguredButton() {
        #expect(UIButton.filled().configuration != nil)
        #expect(UIButton.tinted().configuration != nil)
        #expect(UIButton.plain().configuration != nil)
        #expect(UIButton.bordered().configuration != nil)
    }
}
