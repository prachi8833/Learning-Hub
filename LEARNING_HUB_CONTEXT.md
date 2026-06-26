# Riaan & Kairav Learning Hub — Project Context
> Read this file before making any changes. Last updated: June 2026.

---

## Project Overview

A private gamified learning app for two boys, built by their parent Prachi.
Vision: Animal Crossing + Duolingo + Khan Academy Kids + Habitica + Montessori + Gujarati warmth.

| | |
|---|---|
| **Live URL** | https://prachi8833.github.io/Learning-Hub |
| **GitHub repo** | https://github.com/prachi8833/Learning-Hub |
| **Owner** | Prachi (prachi8833) — IT/cloud admin, Surrey BC Canada |

---

## File Rules

- Main child app lives in `index.html`.
- Parent/admin controls live in `parent_dashboard.html`.
- Do not split into React, Vue, npm, or build tools.
- Keep vanilla HTML + CSS + JavaScript.
- Edit only the file related to the current task.
- Ask before creating new files or deleting files.

---

## The Kids

| | Riaan | Kairav |
|---|---|---|
| Age | 8 | 6 |
| Grade | 3 | 1 |
| Avatar emoji | ♑ | ♈ |
| Brand colour | `#29B0B8` (teal) | `#8266DE` (purple) |
| Quiz length | 30 questions | 15 questions |
| School | Mountainview Montessori, Surrey BC | same |

---

## Tech Stack

| Layer | Choice |
|---|---|
| Frontend | Vanilla HTML + CSS + JavaScript — one file |
| Hosting | GitHub Pages (free, auto-deploys from `main`) |
| Database | Supabase (PostgreSQL) — REST API, no backend server |
| Font | Nunito (Google Fonts) |
| Images | Stored in GitHub repo root, served via `raw.githubusercontent.com` |

### Supabase credentials

```
URL:    https://tnhgihzfwqsflpueivwe.supabase.co
Key:    sb_publishable_MOfPmwQ3sKgia0bnOfrIdw_rY7FaJCr
Region: ca-central-1 (Canada Central)
```

### Supabase helper used throughout

```js
const SB  = 'https://tnhgihzfwqsflpueivwe.supabase.co';
const KEY = 'sb_publishable_MOfPmwQ3sKgia0bnOfrIdw_rY7FaJCr';

const db = (path, opts = {}) => fetch(`${SB}/rest/v1/${path}`, {
  headers: {
    'apikey': KEY,
    'Authorization': `Bearer ${KEY}`,
    'Content-Type': 'application/json',
    'Prefer': opts.prefer || 'return=representation',
    ...opts.headers
  },
  method: opts.method || 'GET',
  body: opts.body ? JSON.stringify(opts.body) : undefined
}).then(r => r.json()).catch(() => []);
```

### Known Supabase quirk
Many rows have `active = null` not `active = true`.  
Queries with `?active=eq.true` may return empty arrays.  
The code always has hardcoded `FALLBACK_*` arrays as a safety net — keep them.

---

## Database Tables

| Table | Purpose |
|---|---|
| `players` | id, name, avatar, grade, age, zodiac, color |
| `subjects` | id, key, name, icon, color, bg_color, active, sort_order |
| `questions` | id, subject_key, grade, level, topic, question, answer, wrong1–3, explanation, active |
| `level_progress` | player_id, subject_key, current_level |
| `sessions` | player_id, subject_key, score, total, stars_earned, passed, distinction, perfect |
| `tasks` | id, title, icon, time_block, stars_value, active, day_type, assigned_to |
| `task_completions` | task_id, player_id, status (`pending`/`approved`/`rejected`), completion_date |
| `stars_log` | player_id, amount, reason, category, created_at |
| `streaks` | player_id, current_streak, longest_streak |
| `wish_list` | player_id, title, star_cost, image_url, active, gifted |
| `active_goals` | player_id, wish_list_id, stars_at_start |
| `reward_shop` | id, title, icon, star_cost, category, active, sort_order |
| `redemptions` | player_id, reward_id, stars_spent, status (`pending`/`approved`) |
| `badges` | id, name, description, icon, condition_type, condition_value, active |
| `earned_badges` | player_id, badge_id, earned_at |
| `reading_passages` | id, title, content, grade, level, topic, word_count, active |
| `motivation_quotes` | id, mood, quote, emoji |
| `modules` | id, subject_key, title, description, level, active |
| `game_templates` | id, name, type, description |
| `game_items` | id, template_id, content, answer |
| `parent_settings` | key, value |

### Question row format

```sql
INSERT INTO questions
  (subject_key, topic, level, grade, question,
   answer, wrong1, wrong2, wrong3, explanation, active)
VALUES
  ('math', 'addition', 1, 1,
   'What is 5 + 3?',
   '8', '7', '9', '6',
   'Count on from 5: 6, 7, 8. So 5 + 3 = 8.', true);
```

- `answer` = correct option (string)
- `wrong1/2/3` = plausible wrong options — never silly/obvious
- Options are shuffled randomly in the quiz UI
- `level` 1–10 = difficulty within subject
- `grade` 1–5 = school year
- `explanation` shown on wrong answer — keep it kind and simple
- No trick questions; plain language for ages 6–10

---

## Curriculum & Content Rules

- Aligned to **BC (British Columbia) Canada** curriculum.
- Canadian spelling throughout: colour, centre, programme, litre.
- Canadian money: CAD dollars, loonies, toonies, quarters, dimes, nickels, cents.
- Geography starts with BC and Canada before expanding outward.
- **Kairav (Grade 1):** simple words, basic math, recognition tasks, very short sessions.
- **Riaan (Grade 3):** word problems, reading comprehension, multiplication, more complex science.

### Subjects

| Key | Name | Notes |
|---|---|---|
| `math` | Math | BC curriculum, CAD money, metric measurements |
| `reading` | Reading | Phonics (Gr 1), comprehension (Gr 3) |
| `science` | Science | Plants, animals, weather, habitats, human body |
| `writing` | Writing | Grammar, punctuation, sentences, creative |
| `social` | Social Studies | BC/Canada geography, community helpers, Indigenous BC |
| `coding` | Coding | Sequences, loops, debugging, basic logic |
| `hinduism` | Hinduism | Gods, festivals, stories, symbols, dharma |
| `hindi` | Hindi | Alphabet, numbers, greetings, common words (taught from scratch) |
| `gujarat` | Gujarat & Culture | Gujarati food, festivals, geography, folk art, language basics |
| `health` | Health & Life Skills | Body safety, emotions, nutrition, hygiene |
| `indigenous` | Indigenous BC | First Nations of BC, land acknowledgements, traditions |
| `music` | Music | Notes, rhythm, instruments (added as stretch subject) |

### Tara's voice (mascot)
Tara is an animated star character who gives encouragement.
Her messages mix English and Hindi naturally:
- "Shabash!" (Well done!)
- "Ek aur try!" (One more try!)
- "Namaste!"
- "Bilkul sahi!" (Absolutely correct!)
- "Bahut acha!" (Very good!)

---

## App Configuration

| Setting | Value |
|---|---|
| Parent PIN | `1820` |
| School | Mountainview Montessori School |
| School hours | 8:30 AM – 2:30 PM |
| Current mode | Summer (school mode ready for September) |
| Wake time | 7:00 AM |
| Bedtime | 9:30 PM |
| Pass threshold | 80% |
| Distinction threshold | 90% |
| Perfect | 100% |

### Star economy

| Event | Stars |
|---|---|
| Correct answer, level 1–2 | +10 |
| Correct answer, level 3–4 | +15 |
| Correct answer, level 5–6 | +20 |
| Correct answer, level 7+ | +25 |
| Session pass bonus | +100 |
| Distinction bonus | +150 |
| Perfect score bonus | +300 |
| Task completion | +5 to +50 (set per task) |
| Reading assessment | +10 to +50 (based on accuracy %) |

---

## App Screens (index.html)

Five main screens — show/hide with `.screen` / `.screen.active`:

| Screen ID | Purpose |
|---|---|
| `#homeScreen` | Hero greeting + stats + goal tracker + today's plan + path map + subjects + wish list |
| `#learnScreen` | Subject islands + continue cards + skills unlocked + progress ring |
| `#tasksScreen` | Daily summary ring + full task list + calendar + week strip + streak garden |
| `#rewardsScreen` | Stars balance + goal unlock bar + reward shop grid + countdown timer |
| `#profileScreen` | Player hero + journey level + strengths + achievements + radar chart |

Overlays (fixed, `z-index` 9999+):

| ID | Purpose |
|---|---|
| `#readingScreen` | Voice reading assessment (Web Speech API) |
| `#quiz` | Multiple-choice quiz overlay |
| `#res` | Quiz results |
| `#pin` | Parent PIN entry (PIN: `1820`) |
| `#pdash` | Quick parent actions (links to `parent_dashboard.html`) |
| `.mov` | Bottom-sheet modal |

Navigation:
- Desktop / iPad: permanent left sidebar (190 px wide)
- Mobile (≤768 px): hidden sidebar, bottom nav bar

---

## Parent Dashboard (parent_dashboard.html)

Standalone file. Nine sections:

1. **Overview** — both kids side-by-side, stars, streak, tasks done today
2. **Pending Approvals** — approve / reject task completions and redemptions
3. **Tasks Manager** — add, edit, toggle, delete tasks; reorder; approval queue
4. **Wish List Manager** — add/edit/delete wish items; mark gifted; set active goal
5. **Reward Shop Manager** — add/edit/delete rewards; approve redemptions
6. **Star Manager** — add or deduct bonus stars with reason; full history
7. **Schedule Manager** — toggle Summer/School mode; edit time blocks
8. **Content Manager** — view question counts; add custom questions
9. **Settings** — change PIN; edit player details; toggle features

---

## Visual Design System

### Theme: Glassmorphism over scene backgrounds

Each screen has a full-bleed background image. All UI elements float on top as frosted glass cards.

### Background images (GitHub repo root)

| Screen | File |
|---|---|
| Player select | `bg-beach-FirstPage.png` |
| Home | `bg-ocean-Home.png` |
| Learn | `bg-castle-forest-day-Learn.png` |
| Tasks | `bg-sunset-village-Tasks.png` |
| Rewards | `bg-treehouse-night-Rewards.png` |
| Profile | `bg-treehouse-airballons-Profile.png` |
| Parent dashboard | `bg-Parents dashboard.png` |

Background image base URL:
```
https://raw.githubusercontent.com/prachi8833/Learning-Hub/main/
```
Spaces in filenames → URL-encode: `Star%20home%20-%20no%20bg.png`

`setBG(screen)` is called inside `navTo()` on every screen change.

### CSS design tokens

```css
:root {
  --teal:   #2BBFB8;   --teal2:  #1A9990;
  --purple: #7C5CBF;
  --amber:  #F6C04A;   --amber2: #E8A020;
  --orange: #F07830;
  --pink:   #E8457A;   --red:    #E84545;
  --green:  #27AE60;   --blue:   #4A90D9;

  --r:      16px;                          /* border-radius */
  --shadow: 0 4px 20px rgba(0,0,0,0.25);

  /* Glass card tokens — use on all new UI elements */
  --gc:     rgba(12,28,18,0.58);           /* card background */
  --gb:     rgba(255,255,255,0.11);        /* card border */
  --gblur:  blur(14px);                    /* backdrop-filter */
}
```

### Text colour rule
All text on glass cards must be white or `rgba(255,255,255, x)`.
Never use dark text on a glass card — the background image shows through.

### Sidebar
Currently: `rgba(6,18,10,0.74)` — feels too solid/dark.  
Target: more transparent, fades into the background scene.  
Pending fix: reduce opacity, increase blur.

### Sparkle overlays (pending)
Each background image has natural light sources (stars, lanterns, water reflections).
Plan: add a `<div id="scene-sparkles">` fixed overlay (pointer-events none, z-index 1)
with per-screen animated CSS dots that match each scene's light sources:
- Home (ocean night) → white star dots in sky + blue-white shimmer on water
- Tasks (sunset village) → warm amber flicker dots near lamp posts
- Rewards (treehouse night) → warm yellow lantern glow dots + firefly drift
- Profile (treehouse + balloons) → white star dots in upper sky
- Learn (castle forest) → gold/white sparkle dots near castle towers

---

## Other Image Assets (GitHub repo root)

### UI images

| File | Use |
|---|---|
| `Star home - no bg.png` | Tara mascot — transparent PNG, shown animated |
| `RK logo.png` | App logo in sidebar (36×36) |

### Subject card images (jpg)
Used as background on subject grid cards with a dark overlay:
```
Maths.jpg  English.jpg  Science.jpg  Hindi.jpg  Hinduism.jpg
Animals.jpg  Art.jpg  Canada.jpg  Coding.jpg  Earth Science.jpg
Festivals.jpg  Human Body.jpg  Life Skills.jpg  Music.jpg  Plants.jpg
Socail Studies.jpg   ← note: typo in filename, keep as-is
Space.jpg  Stories.jpg  Values.jpg  Weather.jpg  World Geography.jpg
```

### Streak garden plant sequence (png)
```
01_Seed.png  →  12_Rainbow_Tree.png   (12 stages total)
```

---

## Key JavaScript Functions (index.html)

| Function | What it does |
|---|---|
| `init()` | Preloads BG images, loads player star counts on select screen |
| `selectPlayer(name)` | Logs in a player, calls `loadPlayer()` then `renderAll()` |
| `loadPlayer()` | Fetches all Supabase data; falls back to hardcoded arrays on failure |
| `navTo(tab)` | Shows correct screen, calls `setBG(tab)`, triggers render |
| `setBG(screen)` | Swaps background image on `#bg-layer` |
| `renderHome/Learn/Tasks/Rewards/Profile()` | Renders each screen |
| `startSubject(key)` | Opens quiz overlay for a subject |
| `loadQ()` | Loads current question into quiz UI |
| `pickQ(btn, chosen, correct, level)` | Handles answer selection |
| `qNext()` | Advances to next question or calls `showQRes()` |
| `showQRes()` | Saves session, awards stars, shows results screen |
| `openReading(taskId)` | Opens reading assessment overlay |
| `startListening()` | Starts Web Speech API recognition |
| `evaluateReading()` | Scores spoken words against passage |
| `submitReading()` | Saves stars to Supabase |
| `showPin()` / `pk(key)` | PIN entry for parent dashboard |
| `buildCalendar()` | Renders monthly calendar in Tasks tab |
| `buildWS()` | Renders week strip in Tasks tab |
| `buildGarden()` | Renders streak garden plants |
| `showMod(html)` / `closeMod()` | Opens/closes bottom-sheet modal |

---

## Coding Rules — Always Follow

1. **Single file per feature** — all child app changes in `index.html` only.
2. **No frameworks** — pure HTML/CSS/JS. No imports. No npm.
3. **Surgical edits** — change only what is asked. Don't restructure other parts.
4. **Keep fallback arrays** — `FALLBACK_SUBJECTS`, `FALLBACK_TASKS`, `FALLBACK_SHOP` must stay.
5. **Glass aesthetic** — new UI elements use `--gc`, `--gb`, `--gblur`.
6. **White text only** — no dark text on glass cards.
7. **Mobile responsive** — new UI must work at ≤768 px with bottom nav.
8. **Pointer-events: none** — on all decorative overlay elements.
9. **Don't break working features** — quiz, reading, tasks, star log, parent PIN.
10. **Output minimal diffs** — give only the changed CSS block or JS function, not the full file, unless the full file is explicitly requested.

---

## What Is Working — Do Not Break

- Supabase data loading with fallback arrays
- Quiz (questions, scoring, star awards, level-up)
- Reading assessment (Web Speech API, word-by-word scoring)
- Task completion with parent approval flow (pending → approved → stars)
- Star economy and wish list goal tracking
- Background image swap per screen (`setBG()`)
- Mobile bottom navigation
- Parent PIN (`1820`) and link to `parent_dashboard.html`
- Countdown timer on rewards screen
- Calendar, week strip, streak garden
- Radar chart on profile screen
- Player select screen with beach background

---

## Pending Issues (ask Prachi for priority before starting)

### 1. Sidebar too dark / opaque
Current: `rgba(6,18,10,0.74)` — looks like a solid dark green block.
Fix: reduce opacity, increase `backdrop-filter` blur so background bleeds through.

### 2. Animated scene sparkles missing
Per-screen sparkle dot overlays not yet built.
See "Sparkle overlays" section above for full spec.

### 3. (Add new issues here as they come up)
