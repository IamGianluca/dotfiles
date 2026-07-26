---
description: Use when writing, reviewing, or refactoring tests. Covers infrastructure wrapping, sociable state-based tests, Given/When/Then structure, A-Frame architecture, dependency injection with fakes, and migrating from mocks. Trigger on test files, unittest.mock, MagicMock, patch, monkeypatch, pytest fixtures with mocks, or any test that interacts with infrastructure (databases, HTTP, file systems, clocks, queues).
---

# Testing Without Mocks

Use this skill when writing, reviewing, or refactoring tests. Apply these patterns whenever tests interact with infrastructure (databases, HTTP, file systems, clocks, queues) or when you see `unittest.mock`, `MagicMock`, `@patch`, `monkeypatch`, or similar test doubles in existing code.

---

## Core Principles

1. **State-based tests.** Assert on return values, observable state changes, and tracked outputs — never on which methods were called or how many times.

2. **Sociable tests.** Let the code under test exercise its real collaborators. Each collaborator has its own tests. The overlap creates a linked chain of coverage equivalent to integration tests, without the slowness.

3. **Narrow tests.** Each test focuses on a specific behavior of a specific unit. No broad end-to-end tests in the main suite (one or two smoke tests are fine as a safety net).

4. **Clean production code.** Production code should have zero awareness of tests. No `create_nullable()` factories, no embedded stubs, no test-only branches in production modules. Test infrastructure lives in test code.

5. **Prefer fakes over mocks.** When a dependency needs to be replaced in tests, write a fake implementation that satisfies the same interface. Fakes live in `tests/` (e.g., `tests/fakes.py` or `tests/conftest.py`). They hold state that tests can inspect — this replaces both mocks and Output Tracking.

---

## Monkeypatching vs Mocking

These are different things that get conflated because they're often used together.

**Monkeypatching** is a *mechanism* — swapping an attribute or function at runtime. `monkeypatch.setattr(httpx.Client, "send", my_replacement)` doesn't care what `my_replacement` is. It could be a Mock, a lambda, a full fake function, or a different real implementation.

**Mocking** is a *testing philosophy* — replacing an object with something that records how it was called, then asserting on those calls. `MagicMock` accepts any attribute access, returns more mocks, and enables interaction-based assertions (`assert_called_with`, `call_count`).

The typical antipattern combines both:

```python
# Monkeypatching + mocking together — avoid this
monkeypatch.setattr(httpx.Client, "send", MagicMock(return_value=Response(200)))
```

But monkeypatching without mocking is fine:

```python
# Monkeypatching with a plain function — no mock, still state-based
def fake_send(self, request, **kwargs):
    return httpx.Response(200, text='{"ok": true}')

monkeypatch.setattr(httpx.Client, "send", fake_send)
```

The second form swaps in a deterministic function at the I/O boundary. No Mock object, no call recording, no interaction assertions. You still test state-based — you check what your code *returned* or *did*, not whether `send` was called with specific args.

**This guide discourages the philosophy (interaction-based testing), not the mechanism (runtime attribute swapping).**

---

## Acceptable Test Doubles (in order of preference)

1. **Dependency injection with fakes.** Define the dependency boundary as a Protocol/ABC (Python) or trait (Rust). Write a fake in test code. Inject it. This is the default approach.

2. **Narrow leaf-level monkeypatching.** When wrapping a third-party library is overkill (e.g., patching `time.time`, `httpx.Client.send`, or `socket.create_connection`), patching the leaf-level I/O call with a plain function is pragmatic and fine. Patch the **lowest-level call**, not your own code. Never patch with a `MagicMock` — use a simple function or lambda that returns a deterministic value.

3. **Nullable infrastructure (James Shore-style).** If you genuinely need a "dry run" or "offline mode" in production, baking `create_nullable()` into the production class is justified. But do this for the production use case, not just for testability.

### What to avoid

- **`MagicMock` / `Mock()` as a stand-in for a dependency** — it accepts any attribute access or method call silently, hiding bugs. A fake that implements a Protocol will fail loudly if the interface changes.
- **Interaction-based assertions** (`assert_called_with`, `assert_called_once`) — they lock tests to implementation. If you refactor how a method delegates, tests break even though behavior is unchanged.
- **Mocking code you own at an interior seam** — this breaks the sociable test chain. Replace the infrastructure boundary, not the collaborator.
- **Patching with Mock objects** — if you reach for `monkeypatch`, the replacement should be a plain function or a fake instance, not a `MagicMock`.

---

## Architecture: A-Frame

Structure the application so that Infrastructure and Logic are peers, with no dependencies between them. The Application layer sits on top and coordinates.

```
        Application / UI
           /       \
          v         v
       Logic    Infrastructure
      (pure)    (external I/O)
```

- **Logic** — pure functions and classes with no infrastructure dependencies. Easy to test directly.
- **Infrastructure** — wrappers around external systems (DB, HTTP, file system, clock, queue). Owns the boundary.
- **Application** — coordinates Logic and Infrastructure using a **Logic Sandwich** or **Traffic Cop**.

### Logic Sandwich

Read from infrastructure, process with logic, write to infrastructure. No interleaving.

```python
class EnrollmentService:
    def __init__(self, db: EnrollmentRepo, clock: Clock):
        self._db = db
        self._clock = clock

    def check_expired(self, user_id: str) -> EnrollmentStatus:
        # Infrastructure: read
        enrollment = self._db.get(user_id)

        # Logic: decide (pure)
        status = enrollment.compute_status(now=self._clock.now())

        # Infrastructure: write
        self._db.update_status(user_id, status)

        return status
```

### Traffic Cop

When the application must react to events (webhooks, message queues), use a traffic cop that routes events to logic and infrastructure calls.

---

## Infrastructure Wrappers

Wrap every external dependency in a class you own. Never let domain code import third-party I/O libraries directly.

Define the wrapper's interface as a Protocol (Python) or trait (Rust). Provide a real implementation and a fake.

### Python: Protocol + Fake

```python
# production code — src/infra/clock.py
from datetime import datetime
from typing import Protocol


class Clock(Protocol):
    def now(self) -> datetime: ...


class SystemClock:
    def now(self) -> datetime:
        return datetime.now()
```

```python
# test code — tests/fakes.py
from datetime import datetime, timedelta


class FakeClock:
    def __init__(self, now: datetime = datetime(2025, 1, 1)):
        self._now = now

    def now(self) -> datetime:
        return self._now

    def advance(self, **kwargs) -> None:
        self._now += timedelta(**kwargs)
```

### Python: Repository

```python
# production code — src/infra/enrollment_repo.py
from typing import Protocol


class EnrollmentRepo(Protocol):
    def get(self, user_id: str) -> Enrollment: ...
    def update_status(self, user_id: str, status: EnrollmentStatus) -> None: ...
```

```python
# test code — tests/fakes.py
class FakeEnrollmentRepo:
    def __init__(self, existing: dict[str, Enrollment] | None = None):
        self._store = dict(existing or {})
        self.writes: list[dict] = []  # output tracking — inspectable state

    def get(self, user_id: str) -> Enrollment:
        return self._store[user_id]

    def update_status(self, user_id: str, status: EnrollmentStatus) -> None:
        self.writes.append({"user_id": user_id, "status": status})
        self._store[user_id] = self._store[user_id].with_status(status)
```

### Python: HTTP Client

```python
# production code — src/infra/http_client.py
from dataclasses import dataclass
from typing import Protocol
import httpx


@dataclass(frozen=True)
class HttpResponse:
    status_code: int
    body: str


class HttpClient(Protocol):
    def get(self, url: str) -> HttpResponse: ...
```

```python
# test code — tests/fakes.py
class FakeHttpClient:
    def __init__(self, responses: dict[str, HttpResponse] | None = None):
        self._responses = responses or {}
        self.requests: list[dict] = []  # output tracking

    def get(self, url: str) -> HttpResponse:
        self.requests.append({"method": "GET", "url": url})
        return self._responses.get(url, HttpResponse(status_code=200, body=""))
```

### Rust: Trait + Fake

In Rust, traits enforce that real and fake implementations satisfy the same contract. The compiler catches drift — the primary argument for keeping stubs in production code disappears.

```rust
// src/infra/clock.rs — production code
pub trait Clock {
    fn now(&self) -> chrono::DateTime<chrono::Utc>;
}

pub struct SystemClock;

impl Clock for SystemClock {
    fn now(&self) -> chrono::DateTime<chrono::Utc> {
        chrono::Utc::now()
    }
}
```

```rust
// tests/fakes.rs — test code
use std::cell::Cell;

pub struct FakeClock(Cell<chrono::DateTime<chrono::Utc>>);

impl FakeClock {
    pub fn new(now: chrono::DateTime<chrono::Utc>) -> Self {
        Self(Cell::new(now))
    }

    pub fn advance(&self, duration: chrono::Duration) {
        self.0.set(self.0.get() + duration);
    }
}

impl Clock for FakeClock {
    fn now(&self) -> chrono::DateTime<chrono::Utc> {
        self.0.get()
    }
}
```

---

## Testing Patterns

### Narrow Integration Tests

For the lowest-level infrastructure wrappers (the ones that actually talk to external systems), test against real systems. Run these locally when possible.

```python
class TestPostgresEnrollmentStore:
    """Narrow integration test — hits a real local database."""

    def test_round_trips_enrollment(self):
        # Given
        store = PostgresEnrollmentStore(test_db_connection())
        enrollment = Enrollment(user_id="u1", status=EnrollmentStatus.ACTIVE)

        # When
        store.save(enrollment)
        result = store.get("u1")

        # Then
        assert result == enrollment
```

These are the **only** tests that touch real external systems. Everything above uses fakes.

### Collaborator-Based Isolation

When a test's expected value depends on a collaborator's behavior, compute the expected value **using the collaborator** rather than hard-coding it. This prevents changes in the collaborator from breaking unrelated tests.

```python
def test_report_includes_address_in_header():
    # Given
    address = Address.create_test_instance()
    report = InventoryReport(inventory=Inventory(), addresses=[address])

    # When
    header = report.render_header()

    # Then — use the collaborator to define the expectation
    assert header == f"Inventory Report for {address.render_as_one_line()}"
```

Use sparingly. It ties the test closer to implementation. Reserve it for cases where hard-coding the expected value would cause cascading test failures from irrelevant collaborator changes.

### Signature Shielding

Protect tests from constructor/method signature changes by centralizing setup in helper functions with optional keyword arguments.

```python
def _run_enrollment_service(
    *,
    existing: dict[str, Enrollment] | None = None,
    now: datetime = datetime(2025, 1, 1),
    advance_days: int = 0,
    user_id: str = "u1",
):
    repo = FakeEnrollmentRepo(existing=existing or {
        user_id: Enrollment(user_id=user_id, status=EnrollmentStatus.ACTIVE)
    })
    clock = FakeClock(now=now)
    service = EnrollmentService(db=repo, clock=clock)

    if advance_days:
        clock.advance(days=advance_days)

    result = service.check_expired(user_id)
    return result, repo.writes
```

### Parameterless Instantiation

Every class should be instantiatable without arguments (via defaults or a factory). This keeps sociable tests simple.

```python
class EnrollmentService:
    def __init__(
        self,
        db: EnrollmentRepo | None = None,
        clock: Clock | None = None,
    ):
        self._db = db or PostgresEnrollmentRepo.create()
        self._clock = clock or SystemClock()
```

### Zero-Impact Instantiation

Don't do significant work in `__init__`. No network calls, no database connections, no heavy computation. Provide a separate `connect()` or `start()` method if needed.

---

## Test Structure: Given / When / Then

Every test uses `# Given`, `# When`, and `# Then` comments.

- **Given** — set up fakes, create domain objects, configure initial state. Answers: "under what conditions?"
- **When** — perform the single action being tested. Answers: "what are we doing?" Keep it to one or two lines.
- **Then** — assert on return values, state, or tracked outputs. Answers: "what should happen?" Never assert on method calls.

```python
def test_expired_enrollment_cannot_be_renewed():
    # Given
    clock = FakeClock(now=datetime(2025, 1, 1))
    enrollment = Enrollment.create(user_id="u1", clock=clock)
    clock.advance(days=31)

    # When / Then
    with pytest.raises(EnrollmentExpiredError):
        enrollment.renew()
```

Always include the comments even for trivial tests. Consistency makes the entire test suite scannable.

---

## Legacy Code: Migrating from Mocks

Work incrementally. You can mix fakes with existing mocks in the same codebase.

1. **Start at the bottom.** Wrap the lowest-level infrastructure (HTTP client, DB driver) behind a Protocol. Write a fake.
2. **Replace one mock at a time.** Pick one mocked dependency per test. Replace the mock with a fake. Run tests.
3. **Convert assertions.** Replace `assert_called_with` / `verify` with state-based checks on the fake's tracked output.
4. **Move up.** Once the bottom layer has fakes, rewrite tests in the layer above, injecting fakes instead of mocks.

Don't waste time converting tests that are already easy to maintain, regardless of how they're tested.

---

## Checklist Before Writing a Test

1. Does the code under test depend on infrastructure? → Inject a fake, not a mock.
2. Am I asserting on return values or state? → Good. Am I asserting on method calls? → Rewrite as state-based.
3. Am I hard-coding expected values that come from a collaborator? → Consider collaborator-based isolation.
4. Does my test helper use keyword arguments with defaults? → Good (signature shielding).
5. Are Given / When / Then comments present? → Required.
6. Does the test name describe behavior? → `test_expired_enrollment_cannot_be_renewed`, not `test_renew`.
7. Is production code free of test-only logic? → Good. Does it have `create_nullable()` or test branches? → Move to test code.

---

## Contributing to Open-Source Projects

When contributing to existing projects, match the project's testing style. These patterns are for code you control. Don't introduce a new testing philosophy into someone else's codebase without consensus.
