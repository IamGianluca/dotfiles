---
name: agent-evals
description: Design, build, and maintain evaluations for AI agents — task sets, graders, eval harnesses, and metrics like pass@k and pass^k. Use this skill whenever the user mentions evals, evaluation suites, benchmarks, LLM-as-judge, graders, regression tests for an agent, "how do I know if my agent got better/worse", agent quality measurement, or is about to ship, tune, or upgrade the model behind an agent — even if they don't use the word "eval". Also use it when the user is writing a spec for a new agent feature, since eval tasks are the sharpest way to make a spec concrete.
---

# Building evals for AI agents

Based on Anthropic's engineering post *Demystifying evals for AI agents* (Jan 2026):
https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents

Agents act over many turns: they call tools, mutate external state, and adapt to intermediate results. Those properties are exactly what makes them useful and exactly what makes them hard to measure. Grading the final assistant message tells you almost nothing — the question is whether the environment ended up in the right state.

The goal of this skill is to get a team from *no evals* to *evals they can trust*, and then keep those evals honest over time.

## Vocabulary — use these words consistently

Sloppy vocabulary here produces sloppy metrics. Fix the terms first.

| Term | Meaning |
|---|---|
| **Task** | One test case: inputs, starting environment, success criteria. Also called a problem. |
| **Trial** | One run of one task. Runs vary, so run several. |
| **Grader** | Logic that scores some aspect of performance. A task may have several, each with multiple assertions. |
| **Transcript** (trace, trajectory) | The complete record of a trial — messages, reasoning, tool calls, intermediate results. |
| **Outcome** | The final environment state. An agent saying "your flight is booked" is transcript; a row in the reservations table is outcome. |
| **Eval harness** | Infrastructure that runs tasks concurrently, records everything, grades, and aggregates. |
| **Agent harness** (scaffold) | The system that turns a model into an agent. Evaluating "an agent" always means evaluating harness + model together. |
| **Suite** | A collection of tasks sharing a broad goal (e.g. refunds, cancellations, escalations). |

The transcript/outcome split is the one that most often gets collapsed by accident. Keep them separate in the data model, because most graders operate on one or the other, not both.

## Two kinds of suites — decide which one you're writing

- **Capability evals** answer "what can this agent do well?" They should *start low*. A capability suite that opens at 90% gives the team no hill to climb.
- **Regression evals** answer "does it still do everything it used to?" They should sit near 100%. A drop is a signal that something broke.

Capability tasks graduate into the regression suite once they're reliably solved. "Can we do this at all?" becomes "can we still do this every time?"

Run both. Hill-climbing on capability without a regression suite is how teams fix one thing and silently break three others.

## The workflow

### Step 0 — Start now, small

20–50 tasks drawn from real failures is a legitimate starting point. Early in an agent's life, each change has a large effect, so small samples still separate signal from noise. Mature agents need bigger, harder suites to detect smaller deltas.

Push back on "we need hundreds of tasks first." Evals get *harder* to write the longer you wait: early on, product requirements convert directly into test cases; later you're reverse-engineering success criteria from a live system.

### Step 1 — Mine what already exists

Sources, in rough order of value:
- The manual checks someone runs before every release
- The bug tracker and support queue (real user-reported failures)
- The most common things users actually ask the agent to do

Prioritize by user impact. A suite grown from real failures reflects real usage; a suite invented in a meeting reflects what the team imagined.

### Step 2 — Write unambiguous tasks with reference solutions

The test for a good task: **two domain experts, working independently, reach the same pass/fail verdict.** If they wouldn't, the ambiguity will show up as noise in the metric. The same standard applies to LLM-judge rubrics — vague rubrics produce inconsistent judgments.

Every task must be passable by an agent that simply follows instructions. This fails in subtle ways. A classic: the task says "write a script," the grader checks a specific filepath, and the task description never mentions that path. The agent fails through no fault of its own.

**Everything the grader checks must be discoverable from the task description.**

Write a **reference solution** for each task — a known-good output that passes all graders. It proves the task is solvable and that the graders are wired up correctly.

Diagnostic: with a frontier model, a 0% pass rate across many trials usually means a broken task, not an incapable agent. Go re-read the spec and the grader before concluding anything about the model.

### Step 3 — Balance the problem set

Test where the behavior **should** fire *and* where it **shouldn't**. One-sided evals produce one-sided optimization: measure only whether the agent searches when it should, and you get an agent that searches for everything.

Anthropic hit this building web search for Claude.ai — they needed tasks for queries that warrant a search (current weather) alongside queries answerable from existing knowledge (who founded Apple). Balancing undertriggering against overtriggering took many rounds on both the prompt and the eval.

Watch for class imbalance generally. If 95% of your tasks expect action, a do-nothing agent scores 95%.

### Step 4 — Build a harness with a stable environment

Two requirements:

1. **The agent under evaluation behaves like the production agent.** If the eval scaffold differs from the real one, you're measuring something nobody ships.
2. **The environment adds no noise of its own.** Each trial starts from a clean state.

Shared state between trials cuts both ways. It causes correlated failures (leftover files, cached data, resource exhaustion) that look like agent regressions but are infrastructure flakiness. It also *inflates* scores — in internal evals, Claude was observed picking up an unfair advantage by reading the git history left behind by previous trials.

When several trials fail for the same environmental reason, they aren't independent samples and the aggregate is not measuring the agent.

### Step 5 — Design graders deliberately

Three families, and good evals combine them:

**Code-based graders** — string/regex/fuzzy match, fail-to-pass and pass-to-pass tests, static analysis (lint, type, security), outcome/state verification, tool-call verification, transcript statistics.
*Fast, cheap, objective, reproducible, easy to debug. Brittle against valid variations; poor at nuance.*

**Model-based graders** — rubric scoring, natural-language assertions, pairwise comparison, reference-based evaluation, multi-judge consensus.
*Flexible, scalable, handles open-ended output. Non-deterministic, costlier, needs calibration against humans.*

**Human graders** — SME review, crowdsourced judgment, spot-check sampling, A/B tests, inter-annotator agreement.
*Gold standard, and the thing you calibrate model graders against. Expensive and slow — spend it judiciously.*

Default: deterministic where possible, model-based where necessary, human occasionally for validation.

Scoring per task can be **binary** (all graders pass), **weighted** (combined score clears a threshold), or hybrid.

Five rules that matter more than the taxonomy:

1. **Grade outcomes, not paths.** There's a strong instinct to assert an exact sequence of tool calls. Resist it — agents routinely find valid approaches the eval author didn't anticipate, and rigid path checks punish exactly the creativity you want.
2. **Build in partial credit.** An agent that identifies the problem and verifies the customer but fumbles the refund is meaningfully better than one that fails at turn one. Represent the continuum.
3. **Give the LLM judge an exit.** Instruct it to return "Unknown" when it lacks information. Otherwise it hallucinates a verdict.
4. **Isolate judge dimensions.** Structured rubric, one dimension per judge call, rather than a single judge scoring everything at once.
5. **Make graders hack-resistant.** Passing should require solving the problem, not finding a loophole in the checker.

**Grading bugs are common and expensive.** Opus 4.5 initially scored 42% on CORE-Bench; investigation turned up rigid grading that rejected `96.12` against an expected `96.124991…`, ambiguous task specs, and stochastic tasks that couldn't be reproduced. After fixes and a less constrained scaffold, the score was 95%. METR similarly found tasks that asked agents to *reach* a threshold while the grader required *exceeding* it — penalizing models that followed instructions. Assume your graders have bugs of this shape until you've verified otherwise.

### Step 6 — Read the transcripts

This is the step teams skip, and it's the one that determines whether the numbers mean anything.

When a task fails, the transcript is what tells you whether the agent made a real mistake or your grader rejected a valid solution. **Failures should look fair**: it should be obvious what went wrong and why. When scores stop climbing, you need confidence that it's the agent and not the eval.

Invest in transcript-viewing tooling early. Read transcripts from many trials, not one.

**Rule of thumb: don't take an eval score at face value until someone has dug into the details and read some transcripts.** If grading is unfair, tasks are ambiguous, valid solutions are penalized, or the harness constrains the model — revise the eval.

### Step 7 — Watch for saturation

An eval at 100% tracks regressions but offers no headroom. As a suite saturates, only the hardest tasks remain, so large real capability gains show up as small score movements — which makes the numbers actively misleading. SWE-bench Verified went from roughly 30% to over 80% within a year.

The code-review company Qodo was initially unimpressed by Opus 4.5 because their one-shot coding evals couldn't see gains on longer, more complex work; they built a new agentic eval framework to get a clearer picture.

If scores are flat near the ceiling, suspect the eval before concluding the model plateaued.

### Step 8 — Treat the suite as living infrastructure

What worked at Anthropic: a dedicated evals team owns the core infrastructure, while domain experts and product teams contribute most of the tasks and run the evals themselves.

For product teams, owning evals should be as routine as maintaining unit tests.

**Practice eval-driven development:** write evals for capabilities the agent *can't yet* deliver, then iterate until it can. Capability evals starting at a low pass rate make those bets legible — when a new model lands, running the suite immediately shows which bets paid off.

Open contribution matters. PMs, customer success, and sales sit closest to the requirements and the users; with Claude Code they can contribute an eval task as a PR. Enable that actively rather than merely permitting it.

## Playbooks by agent type

Don't invent an evaluation approach from scratch. Start from the pattern for your agent type and extend.

### Coding agents

Deterministic grading is natural: does it run, do the tests pass? SWE-bench Verified runs the repo's test suite and passes a solution only if it fixes the failing tests without breaking existing ones. Terminal-Bench instead covers end-to-end technical tasks (build a Linux kernel, train a model).

On top of pass/fail outcome tests, grade the transcript: heuristic code-quality rules, plus a model-based rubric for behaviors like tool use and interaction style.

In practice most coding evals need only unit tests for correctness plus one LLM rubric for code quality. Add more graders when a specific failure mode demands it.

### Conversational agents

The distinguishing feature: the quality of the interaction is itself part of what's being measured. These evals usually need a **second LLM simulating the user** — the approach behind τ-Bench and τ²-Bench, and behind Anthropic's alignment auditing agents.

Success is multidimensional: was the ticket resolved (state check), did it take under N turns (transcript constraint), was the tone right (rubric)? Lean on model-based graders here, because many tasks have several correct answers.

### Research agents

There's no unit test for "comprehensive." Standards shift by context — a market scan, an acquisition diligence memo, and a scientific report all mean different things by "well-sourced." Ground truth also drifts as source content changes, and long open-ended outputs give more surface area for error.

Combine grader types:
- **Groundedness** — every claim traceable to a retrieved source
- **Coverage** — a defined set of key facts a good answer must contain
- **Source quality** — sources are authoritative, not merely first in the result list
- **Exact match** — for genuinely objective sub-questions ("Q3 revenue?")
- **LLM synthesis check** — coherence, completeness, unsupported claims

Calibrate the rubrics against expert human judgment frequently. BrowseComp is a useful reference point: questions easy to verify, hard to solve.

### Computer use agents

Run in a real or sandboxed environment and check the intended outcome actually happened. WebArena verifies URL and page state plus **backend** state for data-modifying tasks — confirming the order exists, not merely that a confirmation page rendered. OSWorld extends this to the whole OS, inspecting filesystem state, app configs, database contents, and UI properties.

Browser agents trade token efficiency against latency: DOM extraction is fast but token-hungry; screenshots are slower but cheaper in tokens. Summarizing a Wikipedia page favors the DOM; shopping on Amazon favors screenshots. For Claude for Chrome, Anthropic built evals specifically checking that the agent picked the right modality per context.

## Non-determinism: pass@k vs pass^k

Every task has its own success rate. One that passed last run may fail the next. Two metrics capture different things, and picking the wrong one misrepresents the product.

- **pass@k** — probability of at least one success in *k* attempts. Rises with *k*. Use when one success is enough (an agent proposing candidate solutions a human reviews). Coding usually cares about pass@1.
- **pass^k** — probability that *all k* trials succeed. Falls with *k*. At a 75% per-trial success rate, three trials all passing is 0.75³ ≈ 42%. Use for user-facing agents where reliability every time is the product requirement.

At k=1 they're identical. By k=10 they tell opposite stories — pass@k approaching 100% while pass^k approaches 0%. Report which one you're using; a headline number without it is meaningless.

## Task definition template

Adapt this shape to whatever harness you use. Include only the graders a task actually needs — the full spread below is for illustration, not a recommended default.

```yaml
task:
  id: "refund-frustrated-customer_1"
  desc: "Customer requests refund for a damaged order under $100; verify identity first."
  setup:
    fixtures: fixtures/orders_seed.sql   # clean state per trial
  graders:
    - type: state_check                  # outcome — the important one
      expect:
        tickets: {status: resolved}
        refunds: {status: processed, amount: "<=100"}
    - type: llm_rubric                   # interaction quality
      rubric: prompts/support_quality.md
      assertions:
        - "Acknowledged the customer's frustration"
        - "Explained the resolution clearly"
        - "Grounded claims in fetch_policy results"
    - type: tool_calls                   # required capabilities, not required order
      required:
        - {tool: verify_identity}
        - {tool: process_refund}
    - type: transcript
      max_turns: 10
  tracked_metrics:
    - type: transcript
      metrics: [n_turns, n_toolcalls, n_total_tokens]
    - type: latency
      metrics: [time_to_first_token, output_tokens_per_sec, time_to_last_token]
  reference_solution: references/refund_reference.json
```

Note `tool_calls` lists *which* tools are required, not the order — see "grade outcomes, not paths."

## Evals are one layer, not the whole picture

Automated evals run thousands of tasks without touching production. They're the first line of defense in CI and pre-launch. They are not sufficient alone — think Swiss cheese: each layer has holes, and the layers cover each other.

| Method | Best for | Watch out for |
|---|---|---|
| **Automated evals** | Fast iteration, every commit, model upgrades | Upfront build cost, ongoing drift, false confidence if tasks don't match real usage |
| **Production monitoring** | Ground truth on real behavior post-launch | Reactive; noisy; no ground-truth labels for grading |
| **A/B testing** | Validating significant changes against real outcomes | Slow, needs traffic, weak on *why* |
| **User feedback** | Surfacing what you didn't anticipate | Sparse, self-selected, skewed to severe issues |
| **Manual transcript review** | Building intuition for failure modes | Doesn't scale; qualitative only |
| **Systematic human studies** | Calibrating model graders; subjective domains | Expensive, slow, needs experts in regulated domains |

Practical cadence: automated evals in CI, monitoring post-launch, A/B for big changes, triage feedback continuously, sample transcripts weekly, reserve human studies for judge calibration.

## Frameworks

Pick one quickly and spend the saved energy on task and grader quality — a framework is only as good as the evals run through it.

- **Harbor** — containerized agent runs, trials at scale across cloud providers, standard task/grader format; Terminal-Bench 2.0 ships through its registry
- **Braintrust** — offline eval plus production observability and experiment tracking; `autoevals` provides prebuilt scorers
- **LangSmith** — tracing, offline/online evals, dataset management, LangChain-native
- **Langfuse** — self-hosted open-source alternative with similar scope
- **Arize** — Phoenix (open-source tracing/eval) and AX (hosted, scale and monitoring)

Plain evaluation scripts are a perfectly reasonable starting point. Many teams mix tools or roll their own.

## Anti-patterns checklist

Run through this before trusting a suite:

- [ ] Grading only the final message instead of environment state
- [ ] Asserting an exact tool-call sequence
- [ ] Tasks where two experts would disagree on pass/fail
- [ ] Grader checks something the task description never stated
- [ ] No reference solution proving the task is solvable
- [ ] Only positive cases — no "should not fire" tasks
- [ ] State leaking between trials
- [ ] Eval scaffold diverging from the production scaffold
- [ ] LLM judge with no "Unknown" escape hatch, or grading all dimensions in one call
- [ ] LLM judge never calibrated against human ratings
- [ ] Reporting a pass rate without saying pass@k or pass^k
- [ ] Nobody has read a transcript
- [ ] Capability suite sitting at 100% (saturated — no signal left)
- [ ] All-or-nothing scoring on multi-part tasks (no partial credit)
- [ ] Suite has no owner and hasn't been touched since launch

## The short version

Start early and small. Source tasks from real failures. Make success criteria unambiguous and verify them with reference solutions. Combine grader types and grade what was produced, not the route taken. Keep the problems hard enough to leave headroom. Iterate to improve signal-to-noise. And read the transcripts.
