---
name: commit
description: >-
  Create focused, atomic git commits following Conventional Commits v1.0.0.
  Each commit is a single logical change with a rationale body explaining why.
  Use when the user says "commit", "make a commit", or wants to commit changes.
user-invocable: true
disable-model-invocation: false
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
---

# /commit — Focused Conventional Commits

Create focused, independent VCS commits that follow
[Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).
Every commit body serves as a durable decision record explaining _why_ changes
were made, so humans and LLMs reviewing history can understand rationale.

## Workflow

1. **Inspect the working tree.** Run `git status` (never `-uall`) and
   `git diff` (staged + unstaged). Read recent `git log --format='%B---' -5`
   to stay consistent with existing style and scope conventions.

2. **Partition into atomic units.** Each commit must be a single, self-contained
   logical change. If the working tree contains multiple independent changes,
   split them into separate commits automatically — one per logical unit.
   A commit is atomic when it answers exactly one "why."

3. **Stage precisely.** Use `git add <path>…` for each commit — never
   `git add -A` or `git add .`. Never stage files that look like secrets
   (`.env`, `credentials.*`, tokens, private keys). Warn the user and refuse
   if detected.

4. **Write the commit message** using the format below.

5. **Verify.** Run `git status` after each commit to confirm success.

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

[<footer(s)>]
```

### Subject Line

| Field       | Rules                                                                                                                                                                                                           |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `<type>`    | One of: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `style`, `build`, `ci`, `chore`, `revert`                                                                                                            |
| `<scope>`   | **Always required.** Use the narrowest accurate scope. Known scopes: `fish`, `nvim`, `tmux`, `git`, `brew`, `ghostty`, `starship`. Freeform scopes allowed for new tools. Use `repo` for cross-cutting changes. |
| `<subject>` | Imperative mood, lowercase, no period, 50 chars max. Describe **what** changed.                                                                                                                                 |
| Breaking    | Append `!` after scope: `feat(fish)!: remove legacy prompt` and add a `BREAKING CHANGE:` footer.                                                                                                                |

### Body

The body is a **micro decision record**. It answers **why**, not what — the
diff shows what. Write it so a developer or an LLM summarizing history can
understand the motivation without reading the code.

Structure as concise prose following this pattern:

- **Problem or motivation** — what prompted the change
- **Approach chosen** — why this solution over alternatives
- **Tradeoffs accepted** — what was given up, if anything

Keep it to 1-4 wrapped lines. Hard-wrap at 72 characters. Use plain prose
with causal connectives ("because", "instead of", "despite"), not bullet
lists — structured prose is easier for LLMs to summarize.

**Trivial opt-out:** A body may be omitted only when ALL of these hold:
the subject fully communicates intent, the diff is self-explanatory, and
there is no non-obvious motivation. Examples: typo fixes, single dependency
additions with obvious purpose, version bumps.

When in doubt, include a body.

### Footers

Use [git-trailer](https://git-scm.com/docs/git-interpret-trailers) format.
Only include footers when applicable — no AI attribution trailers.

| Trailer                          | When                              |
| -------------------------------- | --------------------------------- |
| `BREAKING CHANGE: <description>` | Required for any breaking change. |
| `Refs: <issue or URL>`           | When related to a tracked issue.  |

### Example

```
feat(fish): replace post_exec status with PWD hook

Show directory status (git/jj info, file listing) on cd instead of
after every command. post_exec fired too often and added noise when
running non-navigational commands. A PWD-change hook is the narrower
trigger that matches the actual intent: "show me where I am after I
move."
```

## Multi-Commit Behavior

When the working tree contains multiple independent changes, split them
into separate atomic commits automatically without asking for confirmation.
Apply these heuristics:

- Changes to different subsystems (different scopes) are independent
- A refactoring prerequisite goes in its own commit _before_ the feature commit
- Formatting/style changes are separate from behavioral changes
- Each commit must leave the repo in a valid state

## Hook Failure Handling

If a pre-commit hook fails:

1. **Never** use `--amend` — the commit did not happen, so amending would
   modify the previous unrelated commit.
2. Identify what the hook caught and explain it to the user.
3. Fix the issue and re-stage the affected files.
4. Create a **new** commit with the original message.

## Passing the Message to Git

Always use a heredoc to preserve formatting:

```sh
git commit -m "$(cat <<'EOF'
<type>(<scope>): <subject>

<body>

<footer(s)>
EOF
)"
```

## Prohibitions

- Never `git push` unless the user explicitly asks.
- Never `--no-verify` or `--no-gpg-sign` unless the user explicitly asks.
- Never `--amend` unless the user explicitly asks.
- Never force-push to `main`/`master`.
- Never commit secrets.
