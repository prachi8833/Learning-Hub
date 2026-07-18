# Riaan & Kairav Learning Hub — Architecture (as built)

> Technical documentation of how the app **actually works today**.
> Last verified against production: **2026-07-06** (through PR #14).
>
> Doc precedence: this file is authoritative for *code behavior and
> mechanics*. `LEARNING_HUB_CONTEXT.md` is authoritative for *content,
> curriculum, and visual design* (note: its "Key JavaScript Functions" table
> predates the July 2026 quest rebuild — where the two disagree about code,
> trust this file). `CLAUDE.md` is the browser-debugging policy.

---

## 1. Stack & hosting

| Piece | Choice |
|---|---|
| Frontend | Vanilla HTML + CSS + JS. One self-contained file per feature. No frameworks, no build step, no npm. |
| Hosting | GitHub Pages, auto-deploys `main` (~1 min after push). Live: https://prachi8833.github.io/Learning-Hub |
| Data | Supabase (PostgreSQL) via the REST API (PostgREST), called directly from the browser with the publishable key. No backend server. |
| Images | Repo root, served via `raw.githubusercontent.com`; parent-uploaded overrides in Supabase Storage bucket `backgrounds` via the dashboard's Asset Manager. |
| Region | `ca-central-1`. Project: `tnhgihzfwqsflpueivwe.supabase.co` |

**Local preview must use a real server** (`python -m http.server 8000`) —
`file://` breaks Supabase `fetch`.

**Workflow:** feature branch → `gh pr create` → `gh pr merge --merge
--delete-branch`. Git identity `prachi8833`.

## 2. Page inventory

| File | Size | Role |
|---|---|---|
| `index.html` | ~316 KB | The entire child app: login, 5+2 screens, quiz engine, quest system, reading assessment, tasks, rewards, profile. |
| `parent_dashboard.html` | ~92 KB | Standalone admin app (parent PIN `1820`): approvals, tasks/wish/shop/star/schedule/content managers, Asset Manager, Restart Center. |
| 11 game files | 40–95 KB | Standalone mini-games (see §9). Each is fully self-contained (own CSS/JS/content). |

The 11 games (`GAMES` array, index.html ≈ line 3638; id → file):
`incredible-india`, `math-duel`, `word-builder`, `times-tables-turbo`,
`science-lab`, `geography-quest`, `human-body-explorer`, `story-sequencer`,
`hindi-gujarati-hub`, `world-flags`, `music-dance-explorer` — each
`<id>.html`.

## 3. index.html anatomy

### State
- `S` — the single global state object (player, stars, subjects, modules,
  tasks, wish list, levelProgress, playerProgress, starConfig, quiz state,
  quest-day caches `todaySessions`/`todayReadingCount`/`todayGamesPlayed`/
  `todayStarsEarned`).
- Small per-feature state objects: `RD` (reading), `SL` (subject-learning
  sequence: `{subjKey, topics, topicIdx, questMode}`), `QR` (quest-result
  buttons), `KP` (kid-PIN entry), `GM` (garden modal month).

### Screens & navigation
Seven nav items — `home`, `learn`, `games`, `reading`, `tasks`, `rewards`,
`profile`. All except `reading` are `.screen` divs toggled by `navTo(tab)`
(adds `.active`, swaps background via `setBG(tab)`). The `reading` nav item
calls `openPracticeReading()` directly because reading is an **overlay**, not
a screen — routing it through `navTo()` would break.

Overlays (fixed, own `display` toggling, not part of `navTo`):
`#quiz`, `#res` (results), `#teachScreen`, `#readingScreen`, `#gardenModal`,
`.mov` bottom-sheet (`showMod(html)`/`closeMod()`), `#kidPin`.

### Login & PINs
- Player select → `selectPlayer(name)` → kid PIN pad (`#kidPin`).
  Kid PINs: DB `players.kid_pin` if set, else `DEFAULT_PINS` (riaan `2018`,
  kairav `2020`).
- `localStorage.lh_player` re-logs the same player automatically on return
  (this is how game→hub navigation stays seamless).
- Parent dashboard: `showParentPin()` / `showParentPinFromSelect()` modal →
  PIN `1820` → `parent_dashboard.html`.

### Data refresh model
- `loadPlayer()` fetches everything once at login (parallel `Promise.all`).
- `refreshData()` re-pulls wish/tasks/completions on tab switches.
- **`visibilitychange` handler** (PR #13): when the tab returns to view after
  ≥60 s hidden and no quiz/reading/teach overlay is open, re-pulls the
  `stars_log` balance + today's quest data and re-renders. This is what keeps
  a day-long-open tablet tab honest about parent-awarded stars.

## 4. Data layer

### The `db()` helper
```js
const db=(path,opts={})=>fetch(`${SB}/rest/v1/${path}`,{ ...headers... })
  .then(r=>r.json()).catch(()=>[]);
```
**Every failure is swallowed to `[]`.** Consequences:
- An empty table, an RLS-blocked write, and a network error all look
  identical to the caller. Fallbacks (`FALLBACK_SUBJECTS` etc.) silently
  engage. When debugging "data not loading," query Supabase directly first.
- PostgREST caps one response at **1,000 rows** — any full-table scan must
  paginate with `limit`/`offset` or results silently truncate.

### RLS reality (verified live 2026-07-06, publishable key)
| Table | SELECT | INSERT | UPDATE/DELETE |
|---|---|---|---|
| `subjects` | ✅ | ❌ (42501) | ✅ (hindi was deactivated this way) |
| `modules` | ✅ | ✅ | ✅ |
| `streaks` | ✅ | ✅ | ✅ |
| `player_progress` | ✅ | ❌ **42501 — RLS policy still missing** | — |
| `stars_log`, `sessions`, `level_progress`, `game_scores`, `task_completions`, `redemptions`, `wish_list`, `app_settings` | ✅ | ✅ (app writes these constantly) | ✅ where used |
| Storage bucket `backgrounds` | — | ✅ upload | ❌ delete (orphans accumulate, harmless) |

### Tables the app reads/writes
`players`, `subjects` (7 active; `hindi` deactivated 2026-07-06 — Hindi
lives in the Hindi & Gujarati Hub game instead), `modules` (57 topics),
`questions` (~12,600), `sessions`, `stars_log` (append-only ledger; balance =
sum of `amount`), `level_progress`, `player_progress` (per-topic mastery —
blocked, see §11), `streaks`, `tasks`, `task_completions`, `wish_list`,
`active_goals`, `reward_shop`, `redemptions`, `badges` (12) /
`earned_badges`, `reading_passages` (79), `motivation_quotes`,
`star_config` (see §7), `game_scores` (per-game personal bests, also the
"played today" signal), `app_settings` (Asset Manager key/value),
`parent_settings`. Legacy rows with `subject_key='daily_subjects'` in
`sessions`/`level_progress` are from the pre-July-2026 flow; harmless.

## 5. Today's Quest (the star-earning daily journey)

Five phases on the Home screen "Quest Trail" (`renderQuestTrail()` /
`getQuestState()`): **Subjects → Reading → Games → Dharma (coming soon) →
Exercise**. Reading unlocks after Subjects; Games after Reading. Dharma and
Exercise are always-open side stones (Exercise completes via an approved
task whose title matches /exercise|play|outdoor/i).

### The Quest Plan
`getQuestPlan()` — one plan per player per local day, persisted at
`localStorage.lh_qplan_<playerId>_<date>`: **3 random subjects + 2 random
games**, picked once, surviving the full-page navigation a game requires.
- Self-repairs stale plans: any subject key no longer in `S.subjects` (e.g.
  a subject deactivated mid-day) is swapped for a fresh valid one (PR #11) —
  necessary because phase completion needs 3 *distinct* subject sessions.
- `reconcileQuestPlan()` advances `gameIdx` when a plan game shows up in
  today's `game_scores`, so the trail updates when the kid returns from a
  game.

### Phase completion checks (`getQuestState()`)
- **Subjects:** ≥3 distinct `sessions.subject_key` today. (Distinct, not raw
  count — each subject visit writes 2 session rows, one per topic round.)
- **Reading:** ≥2 `stars_log` rows with `category='reading'` today (two
  passages per day, PR #16). Rows are written even when the daily cap clamps
  the award to 0 — the row, not the stars, is the durable done-signal.
- **Games:** 2 distinct `game_scores.game_key` entries today.

### Quest vs practice — the star gate
`S.questModeQuiz` is set **true only by `startQuestSubject()`** and reset by
the practice entrypoints. `showQRes()` writes `sessions`/`stars_log`/
`level_progress` **only in quest mode**; practice quizzes show the same
results screen but write *nothing* (deliberately — practice session rows
would let a kid "complete" the subjects phase without doing the assigned
subjects). The same rule holds for reading (`practiceMode` flag; also only
the first read of the day earns) and games (`?quest=1` URL param gates each
game's `stars_log` POST; `game_scores` records regardless).

**Stars come from exactly three places:** task approval, the official quest
sequence, and parent bonus stars. Everything else is free practice.

## 6. Subject Learning (quest phase 1 / practice subjects)

Per subject visit: **2 topics** (`pickTopicsForSubject` — random from that
subject's `modules`, avoiding yesterday's pair, persisted on the plan as
`plan.subjectTopics`), and per topic: optional **teach screen** → **10
questions** → results.

- `openTeachScreen()` shows `modules.lesson_content` and skips silently to
  the quiz when it's empty (currently always — column doesn't exist yet,
  §11).
- `startTopicQuiz()` → `pickQuestionsForTopic()` pulls up to 10 questions at
  the player's **per-topic grade/level** (see mastery below), falling back to
  the ungated whole-topic pool when the gated pool is empty, and — in quest
  mode only — falling back to `launchSubjectQuiz()` (whole-subject quiz with
  guaranteed inline questions) when a topic has **zero** questions, so the
  day's quest can never dead-end (PR #11).
- `loadQ()` dispatches on `questions.type` → `renderMCQ` (default; only
  format until the schema migration adds `type`) / `renderFillBlank` /
  `renderWordRearrange` / `renderMatching`, all resolving through the shared
  `resolveQuestion()`.
- Results: pass ≥80 %, distinction ≥90 %, perfect 100 %.

### Adaptive mastery ladder (per player × subject × topic)
Formulas (PR #14, Prachi's spec 2026-07-06):
- **`gradeStart(g) = max(g−1, 1)`** — a never-attempted topic starts one
  grade *below* school grade. Kairav (grade 1) → starts grade 1; Riaan
  (grade 3) → starts grade 2.
- **`gradeAhead(g) = min(g+1, 6)`** — the ceiling a topic can climb to.
  Kairav tops out at grade 2, Riaan at grade 4.
- Within a grade: levels 1–5. Each 10-question round's pass/fail is pushed
  into a rolling window of the last 5 rounds (`recordTopicRoundResult`);
  **4-of-5 passes** → level +1 (window resets); at level 5 → grade +1
  (capped at `gradeAhead`), back to level 1. Never demotes.
- State lives in `player_progress` — currently **not persisting** (RLS, §11);
  it works in-memory per session and fails closed silently.

If Prachi bumps a kid's `players.grade` at real-school promotion, both
formulas shift automatically.

## 7. Star economy

All amounts configurable in `star_config` (read via `starCfg(key, fallback)`),
not hardcoded. Current live values:

| Mechanism | Keys (value) |
|---|---|
| Per correct answer, by question level | `correct_l1_2` (10), `correct_l3_4` (15), `correct_l5_6` (20), `correct_l7_8` (25), `correct_l9_10` (30) |
| Session bonus (quest only) | `level_pass` (100) / `level_distinction` (150) / `perfect_level` (200) |
| Reading (first TWO reads of the day, non-practice) | accuracy-tiered per read: 50/40/30/20/10 at ≥90/80/70/60/below %, through the daily cap (the `reading` star_config key (40) exists but the code uses these accuracy tiers) |
| Tasks | per-task `stars_value`, approved by parent |
| Streak | `daily_streak` (25) each qualifying day, `streak_7` (200), `streak_30` (1000) |
| Monthly prizes | `monthly_bronze` (100) at 1,000 ★/month, `monthly_silver` (300) at 3,000, `monthly_gold` (750) at 6,000 — `checkMonthlyPrize()`, de-duped via `stars_log` reason text, lowest tier first |
| **Daily cap** | `daily_quest_cap` (300) — `applyDailyCap()` in index.html + `applyGameDailyCap()` copied into every game file. Clamps combined `learning,reading,game` earnings per local day. Tasks/bonuses/streaks/prizes deliberately outside the cap. |

**Streaks** (`checkAndUpdateStreak()`, fires when Subjects+Reading+Games are
all done the same day): consecutive-day counter with a 1-shield grace (one
missed day forgiven, `shield_count`). Table schema:
`player_id, current_streak, best_streak, last_active, shield_count`.
The table being empty is *expected* until a kid actually completes all three
required phases in one day.

**Spending:** `reward_shop` redemptions write negative `stars_log` rows
(`category='spend'`) and a `redemptions` row for parent approval.

## 8. Reading assessment

`openReading(taskId, practiceMode)` overlay: passage picker
(`reading_passages`, filtered `grade ≤ player.grade`), Web Speech API
recognition (`startListening()`), word-by-word scoring (`evaluateReading()`).

**Passage rotation (PR #16):** the pool is shuffled with a deterministic
per-day seed (`seededShuffle`, player id + local date → FNV-1a → mulberry32),
and passages read in the last 14 days (localStorage
`lh_readHist_<playerId>`, written by `recordReadingHistory()`) are pushed to
the back — kids see fresh passages first, different order every day.

**Submission (PR #16):** the first TWO non-practice reads of the day count
toward the quest and each earns accuracy stars through the daily cap; the
`stars_log` row is written even at 0 stars (durable completion). After
passage 1 the overlay stays open and `startNextPassage()` auto-advances to a
passage not yet read today; after passage 2 it closes and the trail
re-renders (Choice Games unlocks). Task-linked reads also create a pending
`task_completions` row. Practice mode (sidebar Reading tab) never writes or
earns.

## 9. Mini-game architecture (the per-file contract)

Every game is an island. To add one: create `<name>.html` honoring this
contract and add a `GAMES` entry. The contract every existing game follows:

1. Read `?player=<name>` from the URL; look the player up in Supabase.
2. Read `?quest=1` → `isQuest`; if set, **skip the `stars_log` POST** (quest
   games are tracked, not star-paying — the quest itself pays).
3. On completion: upsert `game_scores` (`best_score`, `best_round`,
   `total_plays`, `last_played`) — *always*, quest or not. This row is also
   how the hub knows the game was played today.
4. Duplicate (do not import — there are no imports) the standard helpers:
   `db()`, `today()` (LOCAL date math — see §10), `applyGameDailyCap()`.
5. Multi-attempt games use the 3-attempt pattern: wrong click disables *that
   button only*, `attempts++`; the 3rd wrong disables all and reveals.
   One-shot games (math-duel, science-lab, story-sequencer,
   times-tables-turbo, word-builder) disable all options on any answer.

**Two hard-won escaping rules for game content strings** (both caused real
production bugs):
- An unescaped `'` inside a single-quoted content string is a syntax error
  that silently kills the *entire page's JS* (geography-quest, fixed
  2026-07-03).
- Escaping for inline `onclick="..."` attributes must be
  `.replace(/'/g,"\\'")` — with `"\'"` (single backslash) the escape is a
  no-op and the button breaks only when apostrophe data lands on it
  (hindi-gujarati-hub, fixed 2026-07-03).

The daily 2-distinct-games cap is enforced identically in all three places
games can be launched (Games tab, Learn grid, quest games picker) — all
render from `renderGames()`-style checks on `S.todayGamesPlayed`.

## 10. Time: everything is LOCAL midnight

`toISOString()` is UTC; in Pacific time the "day" would roll over at ~5 pm.
Rules (bug class fixed app-wide 2026-07-03):
- `today()` builds `YYYY-MM-DD` from local getters. Every file has its own
  copy.
- Bounding `created_at`/timestamptz queries: use `localMidnightISO()` (local
  midnight converted to the correct UTC instant). Never `${today()}T00:00:00`
  — PostgREST has no timezone context for it.
- Any new "is this today / this week" logic must use local getters, never
  `toISOString().split('T')[0]`.

## 11. Pending schema migration (blocks 3 dormant features)

Run in Supabase SQL Editor (exact SQL in `LEARNING_HUB_CONTEXT.md`
appendix). Until then the app degrades gracefully and silently:

| Missing | Dormant feature |
|---|---|
| `player_progress` INSERT RLS policy | Per-topic mastery persists across sessions (currently in-memory only) |
| `modules.lesson_content` column | Teach screens before topic quizzes |
| `questions.type` column | fill-in-blank / word-rearrange / matching question formats (everything renders MCQ) |

## 12. Debugging playbook (lessons that keep paying off)

1. **Read code first, browser second** (repo `CLAUDE.md`). Query live
   Supabase directly when "data isn't loading" — `db()` hides all failures.
2. **Test buttons with real DOM clicks** (`element.click()` or Playwright
   click), never by calling the handler with a fake event — stacking-context
   bugs only show up under real hit-testing. Check
   `document.elementFromPoint()` at the button's center.
3. **Test star-writing flows with fetch interception**: a
   `page.addInitScript` wrapper that blocks/records non-GET Supabase calls
   lets you complete real quizzes without polluting `stars_log`/`sessions`.
4. **"Game won't start at all"** → check the console for a syntax error and
   grep content strings for unescaped apostrophes before suspecting logic.
5. **"Some answer buttons do nothing"** → grep for the broken
   `.replace(/'/g,"\'")` pattern.
6. **Full-table Supabase scans**: paginate past the 1,000-row cap.
7. **Case-insensitive filesystem hazard**: deleting one casing of a
   case-colliding file in git also deletes the shared physical file on
   Windows — restore with `git checkout -- <file>` after the merge.
8. Kids' tablets keep tabs open for days — after a deploy, behavior bugs may
   be *stale code*, not the new code. Have them reload once.

## 13. Changelog (July 2026)

| Date | Change |
|---|---|
| 07-02 | Deep audit: found `star_config`/`streaks` loaded but unused; subjects/questions tables then-empty; timezone bug class identified. |
| 07-03 | Timezone fix app-wide (PR #9); Reading practice tab (PR #10); star economy rebuilt onto `star_config` + daily cap + streaks + monthly prizes; standalone Games tab + 2-games/day cap; quest plan system; **Subject Learning rebuild** (2 topics × teach + 10Q, multi-format engine, adaptive mastery); geography-quest & hindi-gujarati-hub answer-button fixes; topbar dropdown stacking fix. |
| 07-06 | Health-check audit. PR #11: dead hero Start button re-wired, quest zero-question dead-end fallback, stale-plan repair. PR #12: dead `#pin`/`#pdash` overlays removed, garden-legend 404s fixed, `Math-duel.html` case collision resolved. PR #13: star balance refresh on tab visibility. PR #14: `gradeStart`/`gradeAhead` split (start = grade−1, ceiling = grade+1). PR #15: this document. PR #16: Reading phase — durable completion rows (award-gated row-write was leaving the phase permanently not-done once the daily cap was hit, locking Choice Games), two passages/day, per-day passage rotation with 14-day history. Data: `hindi` subject deactivated; 7 orphaned topics given `modules` rows (~1,880 questions unlocked: poetry, prefixes, pujapractice, hanumanchalisa, estimation, patterns, livingthings). |

## 14. Open items

- **Schema migration** (§11) — waiting on Prachi to run the SQL.
- **Dharma Time** quest phase — `comingSoon:true`, content exists in
  `modules`/`questions` (hinduism), UI not built.
- **`indigenous` subject** — 1 module, 0 questions; quest mode falls back to
  the inline-question whole-subject quiz. Needs real questions authored.
- **Streak bar** — requires all of Subjects+Reading+Games in one day; kept
  strict per Prachi's decision 2026-07-06.
- `badges` (12 rows) exist but no earning logic references them yet;
  `earned_badges` empty.
- Thin content: health/social/hindi-legacy topics have ~6 questions each;
  science outside `plants`/`livingthings` likewise.
