---
description: Use when modifying existing code, adding features to legacy or untested code, cleaning up code smells, restructuring modules, or breaking dependencies for testability. Covers code smells (long method, feature envy, shotgun surgery, primitive obsession, etc.), refactoring moves (extract method, move method, replace primitive with object), and legacy code techniques (seams, characterization tests, sprout method, wrap method, scratch refactoring).
---

# Refactoring

Use this skill when modifying existing code: adding features to legacy code, cleaning up code smells, restructuring modules, breaking dependencies for testability, or migrating untested code toward a tested state. Apply these techniques any time code needs to change but the existing design makes the change awkward or risky.

References:
- Martin Fowler, "Refactoring: Improving the Design of Existing Code" (2nd edition, 2018)
- Michael Feathers, "Working Effectively with Legacy Code" (2004)

---

## Core Discipline

**Refactoring and behavior change are separate activities.** Never mix them in the same commit.

- A **refactoring** changes code structure without changing observable behavior. Tests pass before and after.
- A **behavior change** adds, removes, or alters functionality. It has its own commit with its own tests.

If the current design makes a new feature awkward, restructure first (refactoring commit), then add the feature cleanly (behavior change commit). This applies even under time pressure — the two-commit discipline catches mistakes that a combined change hides.

---

## Legacy Code: Getting Started

Legacy code is code without tests. The challenge: you need tests to refactor safely, but the code is often too tangled to test.

### The Legacy Code Dilemma

To change code safely, we need tests. To put tests in place, we often need to change code. Break this cycle with the smallest, safest dependency-breaking techniques available.

### Characterization Tests

Before refactoring, capture what the code *actually does* — not what it *should* do.

A characterization test documents existing behavior. It doesn't assert correctness; it asserts current output. If the test breaks after a refactoring, you changed behavior unintentionally.

```python
def test_calculate_discount_characterization():
    """Characterization test: captures current behavior, not intended behavior."""
    # Given
    order = Order(
        items=[Item(price=100, quantity=2), Item(price=50, quantity=1)],
        customer_type="premium",
    )

    # When
    discount = calculate_discount(order)

    # Then — this is what the code does today, warts and all
    assert discount == 37.5
```

Write characterization tests when:
- You don't fully understand what the code does.
- You need a safety net before restructuring.
- The code has no tests and you need to change it.

Don't spend time making characterization tests comprehensive. Focus on the behavior paths that your upcoming change will affect.

### Effect Sketching

Before changing tangled code, draw (or describe) the effect chain:
- What does this method read?
- What does it write or mutate?
- What other methods depend on those side effects?
- Are there sneaky effects (mutating arguments, globals, class-level state)?

This reveals **pinch points** — places where many effects converge through a narrow path. Pinch points are the best places to write characterization tests because they cover many effects with few tests.

---

## Seams

A seam is a place where you can alter behavior without editing the code at that location. Every seam has an **enabling point** — the place where you choose one behavior over another.

In Python, the most useful seams are:

### Object Seams

Pass a dependency through a constructor or method parameter. The enabling point is the call site where you choose which implementation to provide.

```python
# The constructor parameter is the seam
class InvoiceProcessor:
    def __init__(self, payment_gateway: PaymentGateway):
        self._gateway = payment_gateway

# Enabling point: production code
processor = InvoiceProcessor(StripeGateway.create())

# Enabling point: test code
processor = InvoiceProcessor(PaymentGateway.create_null())
```

This is the preferred seam type. It aligns with nullable infrastructure — the production class itself has a `create_null()` factory, so no separate test double is needed.

### Module Seams

In Python, imports are assignments. You can restructure which module provides a function by extracting it behind an interface or injecting it as a parameter.

```python
# Before: hard-coded dependency, no seam
from vendor_lib import send_email

def notify_user(user):
    send_email(user.email, "Welcome!")

# After: object seam via parameter
def notify_user(user, mailer: Mailer):
    mailer.send(user.email, "Welcome!")
```

### When to Create a Seam

Create a seam when you need to:
- Test code that currently depends on infrastructure.
- Replace a dependency with a nullable version.
- Isolate the area you're about to change.

Do the minimum restructuring needed to create the seam. Don't clean up the whole class — just open the seam, add tests, then make your change.

---

## Adding Features to Legacy Code

When you need to add a feature to untested code, don't just edit the existing method. Use one of these techniques to keep new code tested and isolated.

### Sprout Method

Write the new behavior in a new, tested method. Call it from the existing code.

```python
# Before: untested monster method
class TransactionGate:
    def post_entries(self, entries):
        # ... 200 lines of untested code ...
        for entry in entries:
            entry.post_date()
        self._bundle.add(entries)

# After: new behavior in a tested sprout method
class TransactionGate:
    def post_entries(self, entries):
        # ... 200 lines of untested code ...
        unique_entries = self._deduplicate(entries)  # sprout call
        for entry in unique_entries:
            entry.post_date()
        self._bundle.add(unique_entries)

    def _deduplicate(self, entries: list[Entry]) -> list[Entry]:
        """New, tested method — the sprout."""
        seen = set()
        result = []
        for entry in entries:
            if entry.id not in seen:
                seen.add(entry.id)
                result.append(entry)
        return result
```

Use sprout method when the new behavior logically belongs in the existing algorithm.

### Sprout Class

When the existing class is too tangled to sprout a method into, create a new class entirely.

```python
# New, fully tested class
class EntryDeduplicator:
    def deduplicate(self, entries: list[Entry]) -> list[Entry]:
        ...

# Old code calls the new class
class TransactionGate:
    def post_entries(self, entries):
        # ... untested legacy code ...
        unique = EntryDeduplicator().deduplicate(entries)
        ...
```

Use sprout class when the existing class can't be instantiated in a test harness, or when the new behavior represents a distinct responsibility.

### Wrap Method

When new behavior should execute before or after existing code, wrap the original method.

```python
# Before
class Employee:
    def pay(self):
        # ... complex pay logic ...

# After: rename original, wrap with new method
class Employee:
    def pay(self):
        self._log_payment()       # new behavior (before)
        self._dispatch_pay()      # original logic
        self._notify_payroll()    # new behavior (after)

    def _dispatch_pay(self):
        # ... original complex pay logic, moved here ...

    def _log_payment(self):
        # ... new, tested ...

    def _notify_payroll(self):
        # ... new, tested ...
```

### Wrap Class (Decorator)

The class-level equivalent of wrap method. Create a new class that wraps the legacy class and adds behavior.

```python
class LoggingEmployeePayment:
    def __init__(self, employee: Employee, logger: Logger):
        self._employee = employee
        self._logger = logger

    def pay(self):
        self._logger.log(f"Processing payment for {self._employee.id}")
        self._employee.pay()
```

### Decision Guide

| Situation | Technique |
|---|---|
| New behavior belongs in the existing algorithm | Sprout Method |
| Existing class is too tangled to test | Sprout Class |
| New behavior should run before/after existing code | Wrap Method |
| Need to add behavior without modifying the class at all | Wrap Class |

---

## Code Smells

A code smell is a surface-level indicator that something may be wrong with the design. Smells are not bugs — they're signals that a refactoring might be warranted. Always name the smell when proposing a fix.

### Bloaters

Things that have grown too large.

**Long Method** — A method that's hard to follow in one reading. Extract private helpers for readability, but don't create new public abstractions unless there's a genuine boundary. (See the software-design skill for the deep-modules reconciliation.)

**Large Class** — A class with too many responsibilities, too many instance variables, or too many methods. Look for clusters of variables that change together — each cluster might be a separate class.

**Long Parameter List** — More than 3-4 parameters. Introduce a Parameter Object or preserve the whole object instead of extracting individual fields from it.

**Data Clumps** — Groups of variables that travel together (e.g., `start_date`, `end_date`, `timezone` always appearing as a trio). Extract them into a value object like `DateRange`.

**Primitive Obsession** — Using raw strings, ints, or floats for domain concepts. A phone number is not a string. Money is not a float. Create small domain types.

```python
# Smell: primitive obsession
def create_enrollment(user_id: str, plan: str, amount: float, currency: str):
    ...

# Better: domain types
def create_enrollment(user_id: UserId, plan: Plan, price: Money):
    ...
```

### Change Preventers

Smells that make future changes expensive.

**Divergent Change** — One class changes for many unrelated reasons. The class has multiple responsibilities — split it so each piece changes for one reason.

**Shotgun Surgery** — One logical change requires editing many classes. The responsibility is scattered — consolidate it.

These two are opposites. Divergent change means too many responsibilities in one place. Shotgun surgery means one responsibility spread across too many places.

### Couplers

Smells that indicate excessive coupling.

**Feature Envy** — A method uses more data from another class than from its own. Move the method to the class whose data it envies.

```python
# Smell: feature envy — this method belongs on Enrollment, not Report
class Report:
    def enrollment_summary(self, enrollment):
        days = (enrollment.end_date - enrollment.start_date).days
        status = "active" if enrollment.end_date > datetime.now() else "expired"
        return f"{enrollment.user_id}: {status} ({days} days)"

# Better: behavior lives with the data
class Enrollment:
    def summary(self) -> str:
        days = (self.end_date - self.start_date).days
        status = "active" if self.end_date > datetime.now() else "expired"
        return f"{self.user_id}: {status} ({days} days)"
```

**Middle Man** — A class whose methods do nothing but delegate to another class. If more than half the methods are pure delegation, callers should talk to the real object directly.

**Message Chains** — `a.get_b().get_c().get_d().do_thing()`. The caller is coupled to the entire navigation path. Introduce a method on `a` that hides the chain.

### Dispensables

Things that can be removed.

**Dead Code** — Code that is never executed. Remove it. Version control remembers.

**Speculative Generality** — Abstractions, hooks, or parameters added "in case we need them someday." Remove them. YAGNI. Add them when a real use case arrives.

**Lazy Element** — A class or function that doesn't do enough to justify its existence. Inline it.

**Duplicate Code** — The same logic in multiple places. Extract it — but wait for three instances before extracting. Two might be coincidence; three is a pattern.

### Other Signals

**Repeated Switches** — The same `if/elif` or `match` chain scattered across methods, switching on the same value. Use polymorphism.

**Temporary Field** — An instance variable that's only set in some code paths. This makes the class confusing — the variable should probably be a parameter or live in a different object.

**Comments as Deodorant** — A comment explaining *what* complex code does (not *why*) often signals code that should be refactored until the comment is unnecessary.

---

## Refactoring Moves

The most commonly used refactoring operations. Each one preserves behavior — tests should pass before and after.

### Composing Methods

**Extract Method → private helper.** Pull a fragment of code into a named private method. The name replaces a comment.

**Inline Method.** If a method's body is as clear as its name, inline it back. Don't keep trivial one-line wrappers.

**Extract Variable.** Give a name to a complex expression so the surrounding code reads clearly.

**Replace Temp with Query.** If a temp variable holds a computed value and is used in multiple places, replace it with a method call (if the computation is cheap or cacheable).

### Moving Features

**Move Method.** If a method uses more features from class B than from its own class A, move it to B.

**Move Field.** If a field is used more by another class, move it there.

**Extract Class.** When a class has two or more distinct responsibilities, split it into two classes.

**Inline Class.** When a class doesn't do enough to justify its existence, merge it into the class that uses it.

### Organizing Data

**Replace Primitive with Object.** Turn a raw string, int, or float into a domain type (e.g., `Money`, `EmailAddress`, `UserId`).

**Introduce Parameter Object.** Replace a recurring group of parameters with a value object.

**Preserve Whole Object.** Instead of extracting fields from an object and passing them individually, pass the whole object.

**Replace Type Code with Polymorphism.** When behavior varies by a type code (string or int), replace the conditional logic with subclasses or a strategy.

### Simplifying Conditionals

**Decompose Conditional.** Extract the condition, the then-branch, and the else-branch into named methods.

**Consolidate Conditionals.** When multiple conditionals return the same result, combine them and extract a named method.

**Replace Nested Conditionals with Guard Clauses.** Flat is better than nested. Handle edge cases early and return, leaving the main path unindented.

```python
# Before: nested
def calculate_pay(employee):
    if employee.is_active:
        if employee.is_salaried:
            return employee.salary
        else:
            return employee.hours * employee.rate
    else:
        return 0

# After: guard clauses
def calculate_pay(employee):
    if not employee.is_active:
        return 0
    if employee.is_salaried:
        return employee.salary
    return employee.hours * employee.rate
```

---

## Breaking Dependencies in Legacy Code

These techniques are specifically for getting tangled code under test. They are not refactorings in the strict sense — some temporarily worsen the design to create seams. That's acceptable as a stepping stone toward tested, clean code.

### Parameterize Constructor

If a class creates its own dependencies internally, add them as constructor parameters with defaults.

```python
# Before: hidden dependency, no seam
class ReportGenerator:
    def __init__(self):
        self._db = DatabaseConnection("prod://reports")

# After: seam via parameter with default
class ReportGenerator:
    def __init__(self, db: DatabaseConnection | None = None):
        self._db = db or DatabaseConnection.create()
```

This aligns with nullable infrastructure — callers can now inject `DatabaseConnection.create_null()`.

### Extract Interface / Protocol

When you need to swap a dependency but can't modify it, define a Protocol that describes the methods you use, then program against the Protocol.

```python
from typing import Protocol

class PaymentProcessor(Protocol):
    def charge(self, amount: Money) -> PaymentResult: ...
    def refund(self, transaction_id: str) -> PaymentResult: ...
```

### Subclass and Override Method

When a class does something in a method that makes testing hard (e.g., sending an email), override that method in a test subclass to neutralize the side effect.

```python
# Production class with side effect buried in a method
class OrderProcessor:
    def process(self, order):
        # ... business logic ...
        self._send_confirmation(order)  # side effect

    def _send_confirmation(self, order):
        EmailService.send(order.customer.email, ...)

# Test subclass that neutralizes the side effect
class TestableOrderProcessor(OrderProcessor):
    def _send_confirmation(self, order):
        pass  # neutralized for testing
```

Use this as a stepping stone — ultimately, inject the email service as a nullable dependency and remove the subclass.

### Preserve Signatures

When breaking dependencies, keep method signatures identical as long as possible. The more you change at once, the more risk you introduce. Rename and restructure *after* you have tests.

---

## Scratch Refactoring

When you don't understand a piece of code, refactor it aggressively to learn what it does — then throw the refactoring away. Rename variables, extract methods, reorder logic, delete dead branches. Don't worry about tests or getting it right. The goal is understanding, not production code.

After you understand the code, revert everything, write characterization tests based on what you learned, then do a real, careful refactoring.

---

## Workflow: Changing Legacy Code Safely

1. **Identify what to change.** What feature or fix is needed?
2. **Find the change point.** Where in the code does the change need to happen?
3. **Find the test point.** Where can you observe the effects of the change? Look for pinch points.
4. **Break dependencies.** Create seams using the minimum necessary restructuring.
5. **Write characterization tests.** Capture current behavior around the change point.
6. **Make the change.** Use sprout/wrap if adding new behavior. Refactor if restructuring.
7. **Verify.** All characterization tests still pass. New tests cover the new behavior.

---

## Reconciliation with Testing Without Mocks

Feathers' book relies heavily on mocks and test doubles. When applying his dependency-breaking techniques, **use nullable infrastructure instead of mocks**:

- Where Feathers says "extract interface and create a mock," extract the interface but make the production class nullable (`create_null()` with configurable responses and output tracking).
- Where Feathers says "subclass and override method," use this as a temporary stepping stone, then migrate to constructor injection with a nullable dependency.
- Where Feathers says "create a fake," create an embedded stub inside the production wrapper instead (see the testing skill).

The goal is the same — isolate the code under test from external systems — but the mechanism is nullable infrastructure rather than test doubles. This keeps tests sociable and state-based, and prevents them from locking in implementation details.

---

## When Not to Refactor

- **If there are no tests and you can't add them.** Don't refactor without a safety net. Use the legacy code techniques above to get tests in place first.
- **If you're about to throw the code away.** Don't polish code that's being replaced.
- **If the refactoring doesn't serve a concrete goal.** Refactoring should make a specific upcoming change easier, not just satisfy aesthetic preferences.
- **If you're mixing refactoring with a behavior change.** Stop. Commit one, then do the other.
