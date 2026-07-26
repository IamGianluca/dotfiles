---
description: Use when designing new modules, reviewing code architecture, evaluating API boundaries, splitting or merging classes, handling errors, writing comments, or naming things. Covers deep vs shallow modules, information hiding, defining errors out of existence, pull complexity downward, design it twice, and red flags like pass-through methods, information leakage, and temporal decomposition.
---

# Software Design

Use this skill when designing new modules, reviewing code, refactoring, or evaluating architectural decisions. Apply these principles when proposing API boundaries, splitting or merging classes, handling errors, writing comments, or naming things.

Reference: John Ousterhout's "A Philosophy of Software Design" (2nd edition, 2021)

---

## The Central Idea

**The enemy is complexity.** Complexity is anything about a software system's structure that makes it hard to understand or modify. It manifests in three ways:

1. **Change amplification** — a simple change requires modifications in many places.
2. **Cognitive load** — a developer must hold too much context in working memory to make a change safely.
3. **Unknown unknowns** — it's not obvious what needs to change, or what might break.

Complexity is caused by **dependencies** (when code can't be understood in isolation) and **obscurity** (when important information is not obvious). Complexity is incremental — no single decision ruins a system, but hundreds of small ones do.

---

## Strategic vs. Tactical Programming

**Tactical programming** optimizes for getting the current feature done as fast as possible. Each shortcut adds a small amount of complexity. Over time, the codebase becomes unworkable.

**Strategic programming** treats every task as an opportunity to improve the system's design. Working code is not enough — the code must also have clean structure. Invest roughly 10-20% of development time in design improvements.

When suggesting changes, always ask: does this make the system simpler for the next person, or does it just make it work?

---

## Deep Modules

The most important concept in the book. A module's value is the ratio of **functionality it provides** to the **complexity of its interface**.

```
┌─────────────────────────────┐
│         Interface           │  ← narrow, simple
├─────────────────────────────┤
│                             │
│                             │
│       Implementation        │  ← rich, handles many cases
│                             │
│                             │
│                             │
└─────────────────────────────┘
        DEEP MODULE

┌─────────────────────────────┐
│         Interface           │  ← wide, complex
├─────────────────────────────┤
│       Implementation        │  ← thin, trivial
└─────────────────────────────┘
       SHALLOW MODULE
```

**Deep modules** have simple interfaces and hide significant implementation complexity. The Unix file I/O API is the classic example: five calls (`open`, `read`, `write`, `lseek`, `close`) hide enormous complexity around buffering, permissions, concurrency, disk layout, and file systems.

**Shallow modules** have interfaces that are nearly as complex as their implementations. They don't reduce cognitive load — callers must still understand the details.

### Applying This in Python

```python
# DEEP — simple interface, rich behavior behind it
class RetryPolicy:
    """Executes a callable with exponential backoff, jitter, and circuit breaking."""

    def __init__(self, max_attempts: int = 3, base_delay: float = 1.0):
        self._max_attempts = max_attempts
        self._base_delay = base_delay

    def execute(self, fn: Callable[[], T]) -> T:
        # Handles retries, backoff, jitter, exception classification,
        # circuit breaker state, logging — all hidden from the caller.
        ...
```

```python
# SHALLOW — the interface is as complex as what it does
class RetryConfig:
    max_attempts: int
    base_delay: float
    max_delay: float
    jitter: bool
    backoff_factor: float
    retryable_exceptions: tuple[type[Exception], ...]
    on_retry: Callable | None
    circuit_breaker_threshold: int
    circuit_breaker_reset: float

def retry_with_config(fn, config: RetryConfig) -> Any:
    # Callers must understand every field to use this correctly.
    ...
```

### When extracting methods or classes, ask:

- Does the new abstraction have a simpler interface than the code it replaces?
- Does it hide a meaningful design decision?
- If not, you're just moving complexity around — don't extract.

**Extracting private helpers within a module is fine for readability.** The public interface stays narrow. But creating new public classes should only happen when there is a genuine abstraction boundary.

---

## General-Purpose Modules Are Deeper

A common instinct is to design modules that do exactly what the current use case needs and nothing more. But somewhat general-purpose modules tend to be deeper — they have simpler interfaces because they don't encode use-case-specific assumptions.

The key question: **what is the simplest interface that covers all my current needs?**

```python
# TOO SPECIFIC — encodes one use case into the API
class EnrollmentExpirationChecker:
    def check_and_expire_if_past_trial(self, enrollment_id: str) -> bool:
        ...

# MORE GENERAL — same functionality, wider applicability
class Enrollment:
    def compute_status(self, now: datetime) -> EnrollmentStatus:
        ...
```

Don't over-generalize speculatively — but when you have a choice between an interface that encodes one caller's assumptions and one that doesn't, pick the general one.

---

## Different Layers, Different Abstractions

Each layer in the system should provide a different abstraction from the layers above and below. If two adjacent layers have similar APIs, that's a sign they aren't pulling their weight.

### Red Flag: Pass-Through Methods

A method that does nothing except forward its arguments to another method with the same or similar signature. This indicates that responsibility hasn't been cleanly divided.

```python
# BAD — UserService.get_user just calls UserRepo.get_user
class UserService:
    def get_user(self, user_id: str) -> User:
        return self._repo.get_user(user_id)  # pass-through, adds nothing
```

Fix by either: giving the service real responsibility (validation, authorization, caching), merging the layers, or letting callers use the repo directly.

### Red Flag: Decorators That Add Little

Thin decorator/wrapper classes that delegate nearly everything to the wrapped object. Each one is shallow and adds a new interface to learn. Before creating a decorator, ask if the functionality can be pulled into the existing class.

### Red Flag: Pass-Through Variables

Variables threaded through many method signatures just to deliver them to a deeply nested callee. They force every intermediate method to know about them.

Fix with a context object or by restructuring ownership so the variable is available where it's needed.

---

## Pull Complexity Downward

When there's a choice between making the interface of a module simpler or making its implementation simpler, **choose the simpler interface.** The implementation is written once; the interface is used by every caller.

It's better for a module's author to suffer a complex implementation than to push that complexity onto all callers.

```python
# PUSHES COMPLEXITY UP — callers must handle encoding, headers, retries
def post(self, url: str, body: bytes, headers: dict, retries: int) -> Response:
    ...

# PULLS COMPLEXITY DOWN — module handles the details
def post(self, url: str, payload: dict) -> Response:
    # Internally handles serialization, content-type, retries, auth
    ...
```

---

## Define Errors Out of Existence

Exception handling is one of the worst sources of complexity. Every exception creates a new code path that callers must think about. Often, the best approach is to design the API so the error can't happen.

**Unix vs. Windows file deletion:** On Windows, deleting a file in use raises an error. On Unix, the file is marked for deletion and the call returns successfully — the error is defined out of existence.

**Text editor selection:** Instead of checking everywhere whether a selection exists, make the selection always present with length zero when nothing is selected. The special case disappears.

```python
# BAD — forces callers to handle a case that shouldn't exist
def get_config(self, key: str) -> str:
    if key not in self._config:
        raise KeyError(f"Missing config key: {key}")
    return self._config[key]

# BETTER — define the error out of existence with defaults
def get_config(self, key: str, default: str = "") -> str:
    return self._config.get(key, default)
```

For exceptions that can't be eliminated: **mask** them at a low level (retry internally, use a fallback) or **aggregate** many special cases into one generic handler.

---

## Design It Twice

Before settling on a design, consider at least two fundamentally different approaches. Don't just pick the first idea that works — compare the trade-offs.

This applies at every level: the API of a class, the structure of a module, the layout of a system. Even if you're confident in your first design, the exercise of thinking about alternatives often reveals improvements.

When proposing a design, briefly state what alternative you considered and why you chose the current approach.

---

## Information Hiding and Leakage

### Information Hiding

Each module should encapsulate a design decision — a data format, an algorithm, a communication protocol. Callers should not need to know the decision to use the module.

### Red Flag: Information Leakage

When the same knowledge is embedded in multiple modules. Common forms:

- Two classes that both understand a file format.
- A caller that must know internal implementation details to construct the right arguments.
- Temporal decomposition: splitting code by execution order rather than by information, so the same knowledge (e.g., a file format) spans a "reader" and a "writer" class.

Fix by consolidating the knowledge into one module that owns it.

```python
# LEAKS — callers must know the CSV structure
def load_enrollments(path: str) -> list[dict]:
    """Returns raw dicts with keys matching CSV columns."""
    ...

# HIDES — callers work with domain objects, CSV details are encapsulated
def load_enrollments(path: str) -> list[Enrollment]:
    """Parses enrollment file and returns domain objects."""
    ...
```

---

## Comments

Comments should describe things that are **not obvious from the code**. Good comments capture:

- **Interface documentation** — what a module does, not how. What are the preconditions, postconditions, side effects?
- **Design rationale** — why this approach was chosen over alternatives.
- **Cross-cutting concerns** — things that span multiple modules and can't be localized.

### Red Flags

- Comments that repeat what the code says (`# increment i` next to `i += 1`).
- No comments at all on non-obvious public interfaces.
- Implementation comments in interface documentation (leaking abstraction).

### Writing Comments First

If you write the interface comment before the implementation, it acts as a design tool. If the comment is hard to write, the interface is probably too complex.

```python
class EnrollmentService:
    def expire_if_past_trial(self, user_id: str) -> EnrollmentStatus:
        """Check whether the user's trial period has elapsed and, if so,
        transition the enrollment to EXPIRED status.

        Returns the enrollment's status after evaluation. If the enrollment
        is already expired or cancelled, this is a no-op and returns the
        current status.

        Raises EnrollmentNotFoundError if user_id has no enrollment.
        """
        ...
```

---

## Naming

Good names are precise, consistent, and create a clear mental image.

- **Use names consistently.** If `get` means "fetch from cache" in one place, don't use it to mean "query the database" elsewhere.
- **Avoid vague names.** `result`, `data`, `info`, `manager`, `handler`, `process` — these say almost nothing.
- **Longer names for wider scope.** A loop variable can be `i`. A module-level constant should be `MAX_RETRY_ATTEMPTS`.

### Red Flag: Hard-to-Name Entity

If you can't find a short, precise name for a variable, method, or class, the underlying design may be confused. The entity might be doing too many things, or its responsibility isn't well defined.

---

## Red Flags Summary

Use these as a diagnostic checklist when reviewing code:

| Red Flag | What It Means |
|---|---|
| **Shallow module** | Interface is as complex as the implementation |
| **Information leakage** | Same knowledge duplicated across modules |
| **Temporal decomposition** | Code split by execution order, not by information |
| **Pass-through method** | Method just forwards to another with the same API |
| **Pass-through variable** | Variable threaded through many layers to reach its destination |
| **Repetition** | Same code pattern appears in multiple places |
| **Special-general mixture** | General mechanism contains use-case-specific code |
| **Conjoined methods** | Can't understand method A without reading method B |
| **Hard-to-name entity** | Can't find a precise name — likely confused responsibility |
| **Hard-to-describe interface** | Can't write a concise comment — interface is too complex |
| **Nonobvious code** | Reader can't understand what code does without deep analysis |

---

## Applying These Principles

When designing or reviewing code:

1. **Start with the interface.** Write the comment/docstring first. If it's hard to describe, simplify the design.
2. **Design it twice.** Consider at least one alternative approach before committing.
3. **Pull complexity down.** Choose the simpler interface even if it means a harder implementation.
4. **Eliminate errors.** Ask "can I design this so this error condition doesn't exist?"
5. **Check the red flags.** Scan for pass-through methods, information leakage, and shallow modules.
6. **Think strategically.** Does this change make the system simpler for the next person? Or does it just make the current ticket work?

When extracting or splitting code:

- Will the new module be **deep** (simple interface, rich functionality)?
- Does it **hide a design decision** that callers shouldn't know about?
- Are the layers providing **different abstractions**?
- If the answer to any of these is no, reconsider the extraction.
