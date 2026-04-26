import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIView+Animation extension")
struct UIViewAnimationTests {

    @Test("animate runs the animations closure synchronously on the main actor")
    func runsAnimationsClosure() {
        var ran = false
        UIView.animate(.fast) {
            ran = true
        }
        #expect(ran == true)
    }

    @Test("animate applies the closure's mutations to the view")
    func appliesMutations() {
        let sut = ViewFixture.standalone()
        sut.alpha = 1
        UIView.animate(.fast) {
            sut.alpha = 0
        }
        #expect(sut.alpha == 0)
    }

    @Test("animate with completion eventually invokes the completion handler")
    func invokesCompletion() async {
        let sut = ViewFixture.standalone()
        sut.alpha = 1
        await withCheckedContinuation { continuation in
            UIView.animate(
                .fast,
                animations: { sut.alpha = 0 },
                completion: { _ in
                    continuation.resume()
                }
            )
        }
        #expect(sut.alpha == 0)
    }
}
