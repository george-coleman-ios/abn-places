# Agent Instructions

## Agent Behavior

- **Never make assumptions.** If requirements are unclear, the expected behavior is ambiguous, or multiple valid approaches exist, ask the developer before proceeding. This applies to architecture decisions, naming choices, implementation patterns, and any situation where the right answer depends on context you don't have.
- **Never commit or push.** Do not run `git commit`, `git push`, or create branches. All version control actions are the developer's responsibility. You may suggest commit messages or show diffs if asked, but the final commit is always manual.
- **Ask clarifying questions.** When a task could be interpreted multiple ways, present the options and ask which the developer prefers. Prefer multiple-choice where possible. It is always better to ask one clarifying question than to write 200 lines of code based on an assumption.
- **Tone: friendly but professional.** Be helpful and approachable without being overly casual. No filler, no fluff, no excessive praise. Be direct.
- **Follow existing conventions over general best practices.** When the project's documented standards or established patterns differ from general conventions, follow the project's approach. When no standard exists, follow best practices and flag the decision to the developer.
- **When patterns exist in code but aren't documented,** and you notice inconsistency, present both approaches and let the developer decide which is more appropriate.
- **Keep diffs small.** Prefer editing existing files over creating new ones. Make focused, minimal changes that address the task at hand.
- **Don't add dependencies.** Do not introduce new packages or libraries without asking the developer first.

**Before completing any task:**

1. Run the linter on modified files if one is configured
2. Fix any violations before presenting the final result
3. Run relevant tests to verify changes work

---

## Swift & iOS Standards

### Architecture

- **ViewModels depend on UseCases, not Repositories directly.** Business decisions belong in UseCases. ViewModels handle UI concerns only: loading states, error formatting, navigation.
- **Inward-only dependencies.** Domain layer has zero dependencies on feature or framework modules.
- **Framework-free domain.** No UIKit, SwiftUI, Combine, or persistence types in domain models or UseCases.
- **Protocol boundaries.** Cross-layer communication through protocols defined by the consuming (inner) layer.
- **Convert data at boundaries.** API DTOs -> domain models (in repositories). Domain models -> UI models (in ViewModels). No type crosses more than one boundary unchanged.
- **Dependency injection via initializer** (preferred). All injected dependencies typed as protocols, not concrete types (except pure value types and stdlib types).

### Code Style

- Follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).
- **Classes must be explicitly `final` or `open`.**
- **No force unwrapping in production code.** Only allowed in test code.
- **Factory methods use `make` prefix.**
- **SwiftUI View bodies must not invoke functions with side effects.** Side effects go in `onAppear`, `task`, `onChange`, or equivalent lifecycle modifiers.
- **Extensions** must either implement a protocol conformance or group methods serving a single named capability.

### Swift Concurrency

- **On `@MainActor`:** Views and ViewModels — anything that directly or indirectly triggers UI updates.
- **Not on `@MainActor`:** UseCases, Services, Repositories — unless they specifically need UI access.
- **Async/await** is the primary pattern for asynchronous code.
- Do not change the project's Swift language version or Strict Concurrency settings unless asked.

---

## Testing

### Test Naming

```
test_stateUnderTest_expectedBehavior()
```

### Test Structure (Given/When/Then)

```swift
func test_example_expectedResult() {
    // Given
    let sut = MyClass()
    let expected = "result"

    // When
    let result = sut.doSomething()

    // Then
    XCTAssertEqual(expected, result, "Expected \(expected), got \(result) instead")
}
```

- **Given:** Input, SUT setup, expected result.
- **When:** Call the method under test.
- **Then:** Assert expected equals actual. Include a message stating what was expected and what was received.
