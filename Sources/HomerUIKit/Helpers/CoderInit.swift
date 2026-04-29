import UIKit

/// Replaces the boilerplate `init?(coder:)` storyboard trap on
/// programmatic UIKit views and view controllers.
///
/// Programmatic UIKit components don't support storyboard
/// rehydration; calling this helper from `init?(coder:)` makes that
/// contract explicit at the call site without leaking the literal
/// `fatalError` boilerplate into every subclass.
///
/// ```swift
/// required init?(coder: NSCoder) { unsupportedCoderInit() }
/// ```
///
/// The trap reports the call site (`#fileID` / `#line`) so debugging
/// surfaces the offending subclass, not this helper.
@MainActor
public func unsupportedCoderInit(
    file: StaticString = #fileID,
    line: UInt = #line
) -> Never {
    fatalError("init(coder:) has not been implemented", file: file, line: line)
}
