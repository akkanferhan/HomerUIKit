import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIView+Embed extension")
struct UIViewEmbedTests {

    // MARK: embed(_:insets:)

    @Test("embed adds the child to subviews and returns it")
    func embedAddsAndReturnsChild() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let child = UIView()
        let returned = container.embed(child)
        #expect(container.subviews.contains(child))
        #expect(returned === child)
    }

    @Test("embed activates four edge constraints on the container")
    func embedActivatesFourConstraints() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        container.embed(UIView())
        #expect(container.constraints.count == 4)
    }

    @Test("embed with insets feeds them through to pinToSuperview")
    func embedWithAsymmetricInsets() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let child = UIView()
        container.embed(child, insets: UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
        let constants = Set(container.constraints.map(\.constant))
        #expect(constants.contains(1))
        #expect(constants.contains(2))
        #expect(constants.contains(-3))
        #expect(constants.contains(-4))
    }

    @Test("embed with spacing token applies the value to every edge")
    func embedWithSpacingToken() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        container.embed(UIView(), spacing: .medium)
        let positiveCount = container.constraints.filter { $0.constant == 16 }.count
        let negativeCount = container.constraints.filter { $0.constant == -16 }.count
        #expect(positiveCount == 2)
        #expect(negativeCount == 2)
    }

    // MARK: removeAllSubviews

    @Test("removeAllSubviews empties the subviews array")
    func removeAllSubviewsEmptiesContainer() {
        let container = UIView()
        container.addSubviews(UIView(), UIView(), UIView())
        #expect(container.subviews.count == 3)
        container.removeAllSubviews()
        #expect(container.subviews.isEmpty)
    }

    @Test("removeAllSubviews does nothing when the container has no subviews")
    func removeAllSubviewsOnEmptyContainerNoCrash() {
        let container = UIView()
        container.removeAllSubviews()
        #expect(container.subviews.isEmpty)
    }
}
