# AGENTS.md

## Design Philosophy

Fight complexity. Every change should make the codebase simpler, not just correct.

- **Deep modules over shallow ones.** Modules should have simple interfaces and rich functionality. A class with many methods that each do little is a red flag — prefer fewer methods that each handle significant logic behind a clean API. When a method body grows long, extract into private helpers — this improves readability without making the module shallower. Be much more deliberate about extracting into *new public classes*; only do that when there is a genuine abstraction boundary, not just because a function got long.
- **Locality of behavior.** The behavior of a piece of code should be apparent by reading that piece of code, without tracing through layers of indirection. Prefer colocating related logic over scattering it across abstractions. Don't introduce a strategy interface, a factory, and a registry to avoid an if-statement.
- **Define errors out of existence.** Design APIs so invalid states are unrepresentable rather than adding defensive checks and error handling everywhere.
- **Information hiding.** Each module should encapsulate design decisions. If changing an implementation detail forces changes in callers, the abstraction is leaking.
- **Strategic programming.** Invest in good design now. Don't take tactical shortcuts that accumulate complexity. A working patch that muddies the design is not done.

## Domain-Driven Design

- Use **ubiquitous language**: name classes, methods, and variables using the domain language, not technical jargon. If the domain says "enrollment," don't call it "user_record."
- Separate the domain layer from infrastructure. Domain objects must not depend on databases, HTTP, or frameworks.
- Model **value objects** for concepts with no identity (e.g., DateRange, Money). Make them immutable.
- Model **entities** for concepts with identity that persists across state changes.
- Protect invariants through **aggregates** — don't allow external code to reach into an aggregate's internals and mutate state directly.
- Respect **bounded contexts**. Don't create god models that serve every use case. Different contexts can have different representations of the same concept.

## Refactoring

- **Refactor before adding features.** If the current design makes a new feature awkward, restructure first in a separate commit, then add the feature cleanly.
- Take **small, safe steps**. Each refactoring move should keep tests passing. Never combine a refactoring with a behavior change in the same commit.
- Watch for code smells: long methods, feature envy, data clumps, primitive obsession, shotgun surgery. Name the smell when proposing a fix. For long methods, extract private helpers first — only introduce new public types when there is a real abstraction boundary (see Design Philosophy).
- Extract only when you see **actual duplication or a missing abstraction**, not speculatively. Three instances of similar code is a signal; one is not.

## Testing

- **No mocks.** Do not use unittest.mock, MagicMock, monkey-patching, or similar test doubles that mimic real dependencies. They couple tests to implementation details and break on refactors.
- Prefer **fakes**: hand-written classes in test code that implement the same interface as the real dependency (e.g. a `FakeHttpClient` with a configurable response table). Fakes are not mocks — they implement real, predictable logic without real I/O, so interface drift fails loudly instead of silently passing. Production code defines the seam (Protocol/ABC); fakes implement it.
- **Inject fakes through constructors.** Adapters and services accept external dependencies as optional `__init__` parameters defaulting to the real implementation. Production callers omit them; test callers pass fakes. Never subclass or monkey-patch production classes to inject test doubles.
- Fakes live in **test code** (e.g. `tests/fakes/`), never in production. Production code has zero awareness of tests.
- File-based adapters (JSON files, SQLite, ...) are usually best tested against real I/O with pytest `tmp_path`, not a fake filesystem.
- Tests should be **sociable** — exercise real code paths through collaborating objects. Only the outermost infrastructure boundary gets a fake.
- Use **Given / When / Then** comments to structure every test:

```python
def test_enrollment_expires_after_trial_period():
    # Given
    clock = FakeClock(now=datetime(2025, 1, 1))
    enrollment = Enrollment.create(user_id="u1", clock=clock)

    # When
    clock.advance(days=31)
    result = enrollment.check_status()

    # Then
    assert result == EnrollmentStatus.EXPIRED
```

- Test **behavior, not implementation**. Assert on observable outcomes (return values, state changes, side effects at the infrastructure boundary), not on which internal methods were called.
- Name tests after the behavior they verify, not the method they call: `test_expired_enrollment_cannot_be_renewed` not `test_renew_raises`.

## Code Style

- Prefer **composition over inheritance**.
- Write **docstrings for non-obvious public interfaces** — explain what and why, not how.
- Keep functions short enough to understand in one reading. When extracting, prefer private helpers within the same module over new public abstractions.

## When Suggesting Changes

- Always explain **why** a change reduces complexity or improves the design, not just what the change is.
- If a refactoring skill is available, read it before proposing structural changes.
- If a testing skill is available, read it before writing or modifying tests.
