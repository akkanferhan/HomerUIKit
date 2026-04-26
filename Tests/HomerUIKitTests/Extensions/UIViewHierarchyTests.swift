import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIView+Hierarchy extension")
struct UIViewHierarchyTests {

    // MARK: Variadic overload

    @Test("addSubviews variadic adds all views in declaration order")
    func variadicAddsViewsInOrder() {
        let container = ViewFixture.standalone()
        let a = UIView(), b = UIView(), c = UIView()
        container.addSubviews(a, b, c)
        #expect(container.subviews == [a, b, c])
    }

    @Test("addSubviews variadic with single view adds that view")
    func variadicSingleView() {
        let container = ViewFixture.standalone()
        let a = UIView()
        container.addSubviews(a)
        #expect(container.subviews == [a])
    }

    @Test("addSubviews variadic with empty call adds nothing")
    func variadicEmptyCallAddsNothing() {
        let container = ViewFixture.standalone()
        container.addSubviews()
        #expect(container.subviews.isEmpty)
    }

    // MARK: Array overload

    @Test("addSubviews array overload adds all views in declaration order")
    func arrayOverloadAddsViewsInOrder() {
        let container = ViewFixture.standalone()
        let a = UIView(), b = UIView()
        container.addSubviews([a, b])
        #expect(container.subviews == [a, b])
    }

    @Test("addSubviews with empty array adds nothing")
    func arrayOverloadEmptyAddsNothing() {
        let container = ViewFixture.standalone()
        container.addSubviews([])
        #expect(container.subviews.isEmpty)
    }
}
